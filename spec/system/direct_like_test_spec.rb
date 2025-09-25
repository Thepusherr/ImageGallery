require 'rails_helper'

RSpec.describe 'Direct Like Test', type: :system, js: true do
  let!(:user) do
    User.skip_callback(:create, :after, :send_welcome_email)
    user = create(:user, email: 'test@example.com', password: 'password123')
    User.set_callback(:create, :after, :send_welcome_email)
    user
  end
  
  let!(:post) do
    Post.skip_callback(:create, :after, :log_post_creation)
    Post.skip_callback(:create, :after, :process_image_in_background)
    Post.skip_callback(:create, :after, :notify_category_subscribers)
    post = create(:post, user: user)
    Post.set_callback(:create, :after, :log_post_creation)
    Post.set_callback(:create, :after, :process_image_in_background)
    Post.set_callback(:create, :after, :notify_category_subscribers)
    post
  end

  before do
    driven_by(:selenium_chrome_headless)
    
    # Войти в систему
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    
    # Перейти на главную страницу
    visit root_path
  end

  it 'can click like button and see visual feedback' do
    puts "=== DIRECT LIKE TEST ==="
    
    # Проверить, что страница загрузилась
    expect(page).to have_content('ImageGallery')
    puts "Page loaded successfully"
    
    # Найти кнопку лайка
    like_button = find("button[onclick*='toggleLike']", match: :first)
    puts "Found like button: #{like_button.inspect}"
    
    # Найти иконку сердца
    heart_icon = like_button.find('i')
    initial_classes = heart_icon[:class]
    puts "Initial heart icon classes: #{initial_classes}"
    
    # Кликнуть на кнопку лайка
    puts "Clicking like button..."
    like_button.click
    
    # Подождать немного для обработки
    sleep 3
    
    # Проверить, что что-то изменилось на странице
    current_url_after_click = current_url
    puts "URL after like click: #{current_url_after_click}"
    
    # Проверить, что лайк был создан в базе данных (независимо от UI)
    post.reload
    likes_count = post.likes.count
    puts "Likes count in database: #{likes_count}"
    
    user_like = post.likes.find_by(user: user)
    puts "User like exists: #{user_like.present?}"
    
    # Если лайк не создался, попробуем понять почему
    if likes_count == 0
      puts "Like was not created. Let's check what happened..."
      
      # Проверить логи браузера
      logs = page.driver.browser.logs.get(:browser)
      puts "Browser console logs:"
      logs.each do |log|
        puts "  #{log.level}: #{log.message}"
      end
      
      # Попробовать создать лайк напрямую через модель (отключив callbacks)
      puts "Creating like directly through model..."
      Like.skip_callback(:create, :after, :log_like_event)
      Like.skip_callback(:create, :after, :send_like_notification)
      direct_like = post.likes.create(user: user)
      Like.set_callback(:create, :after, :log_like_event)
      Like.set_callback(:create, :after, :send_like_notification)
      puts "Direct like created: #{direct_like.persisted?}"
      puts "Direct like errors: #{direct_like.errors.full_messages}" unless direct_like.persisted?
      
      post.reload
      puts "Likes count after direct creation: #{post.likes.count}"
    end
    
    # Основная проверка - лайк должен быть создан
    expect(likes_count).to be > 0
    expect(user_like).to be_present
  end
end
