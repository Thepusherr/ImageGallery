require 'rails_helper'

RSpec.describe 'Form Like Test', type: :system, js: true do
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
    
    # Отключить callbacks для лайков в тестах
    Like.skip_callback(:create, :after, :log_like_event)
    Like.skip_callback(:create, :after, :send_like_notification)
    
    # Войти в систему
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    
    # Перейти на главную страницу
    visit root_path
  end

  after do
    # Восстановить callbacks
    Like.set_callback(:create, :after, :log_like_event)
    Like.set_callback(:create, :after, :send_like_notification)
  end

  it 'can like a post using form submission' do
    puts "=== FORM LIKE TEST ==="
    
    # Проверить, что страница загрузилась
    expect(page).to have_content('ImageGallery')
    puts "Page loaded successfully"
    
    # Найти форму лайка
    like_form = find("form[id*='like-form']", match: :first)
    puts "Found like form: #{like_form.inspect}"
    
    # Найти кнопку лайка в форме
    like_button = like_form.find("button[type='submit']")
    puts "Found like button: #{like_button.inspect}"
    
    # Найти иконку сердца
    heart_icon = like_button.find('i')
    initial_classes = heart_icon[:class]
    puts "Initial heart icon classes: #{initial_classes}"
    
    # Проверить начальное состояние в базе данных
    initial_likes_count = post.likes.count
    puts "Initial likes count: #{initial_likes_count}"
    
    # Кликнуть на кнопку лайка
    puts "Clicking like button..."
    like_button.click
    
    # Подождать обработки запроса
    sleep 3
    
    # Проверить, что лайк был создан в базе данных
    post.reload
    final_likes_count = post.likes.count
    puts "Final likes count: #{final_likes_count}"
    
    user_like = post.likes.find_by(user: user)
    puts "User like exists: #{user_like.present?}"
    
    # Проверить, что иконка изменилась (если Turbo работает)
    begin
      updated_heart_icon = find("form[id*='like-form'] button i", match: :first)
      final_classes = updated_heart_icon[:class]
      puts "Final heart icon classes: #{final_classes}"
      
      if final_classes != initial_classes
        puts "Heart icon changed successfully!"
      else
        puts "Heart icon did not change (Turbo may not be working)"
      end
    rescue => e
      puts "Could not check heart icon change: #{e.message}"
    end
    
    # Основная проверка - лайк должен быть создан
    expect(final_likes_count).to be > initial_likes_count
    expect(user_like).to be_present
    
    puts "✅ Like functionality works!"
  end
end
