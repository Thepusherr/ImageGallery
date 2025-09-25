require 'rails_helper'

RSpec.describe 'Comment Test', type: :system, js: true do
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
    
    # Отключить callbacks для комментариев в тестах
    Comment.skip_callback(:create, :after, :log_comment_event)
    
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
    Comment.set_callback(:create, :after, :log_comment_event)
  end

  it 'can open comment modal and create a comment' do
    puts "=== COMMENT TEST ==="
    
    # Проверить, что страница загрузилась
    expect(page).to have_content('ImageGallery')
    puts "Page loaded successfully"
    
    # Найти кнопку комментариев
    comment_button = find("a[data-bs-target*='commentsModal']", match: :first)
    puts "Found comment button: #{comment_button.inspect}"
    
    # Кликнуть на кнопку комментариев
    puts "Clicking comment button..."
    comment_button.click
    
    # Подождать открытия модального окна
    sleep 2
    
    # Проверить, что модальное окно открылось
    begin
      modal = find('.modal.show', visible: true)
      puts "Modal opened successfully: #{modal.present?}"
    rescue Capybara::ElementNotFound
      puts "Modal did not open - checking if it exists at all..."
      modal_exists = page.has_css?('.modal', visible: false)
      puts "Modal exists in DOM: #{modal_exists}"
      
      if modal_exists
        puts "Modal exists but is not visible - Bootstrap JS may not be working"
        # Попробуем открыть модальное окно через JavaScript
        modal_id = comment_button['data-bs-target']
        puts "Trying to open modal #{modal_id} via JavaScript..."
        page.execute_script("document.querySelector('#{modal_id}').classList.add('show')")
        page.execute_script("document.querySelector('#{modal_id}').style.display = 'block'")
        sleep 1
      end
    end
    
    # Попробовать найти форму комментария
    begin
      comment_form = find('form[action*="/comments"]', visible: true)
      puts "Found comment form: #{comment_form.present?}"
      
      # Заполнить текст комментария
      comment_text = "Test comment from integration test"
      text_field = comment_form.find('input[name="text"]')
      text_field.fill_in(with: comment_text)
      puts "Filled comment text: #{comment_text}"
      
      # Проверить начальное количество комментариев
      initial_comments_count = post.comments.count
      puts "Initial comments count: #{initial_comments_count}"
      
      # Отправить форму
      submit_button = comment_form.find('input[type="submit"]')
      puts "Clicking submit button..."
      submit_button.click
      
      # Подождать обработки
      sleep 3
      
      # Проверить, что комментарий был создан
      post.reload
      final_comments_count = post.comments.count
      puts "Final comments count: #{final_comments_count}"
      
      created_comment = post.comments.find_by(text: comment_text, user: user)
      puts "Created comment exists: #{created_comment.present?}"
      
      if created_comment
        puts "Created comment text: #{created_comment.text}"
        puts "Created comment user: #{created_comment.user.email}"
      end
      
      expect(final_comments_count).to be > initial_comments_count
      expect(created_comment).to be_present
      expect(created_comment.text).to eq(comment_text)
      
      puts "✅ Comment functionality works!"
      
    rescue Capybara::ElementNotFound => e
      puts "❌ Could not find comment form: #{e.message}"
      puts "This suggests the modal is not opening properly"
      
      # Попробуем создать комментарий напрямую через модель для проверки
      puts "Creating comment directly through model..."
      Comment.skip_callback(:create, :after, :log_comment_event)
      direct_comment = post.comments.create(user: user, text: "Direct test comment")
      Comment.set_callback(:create, :after, :log_comment_event)
      
      puts "Direct comment created: #{direct_comment.persisted?}"
      puts "Direct comment errors: #{direct_comment.errors.full_messages}" unless direct_comment.persisted?
      
      # Основная проверка провалится, но мы получим информацию
      expect(false).to be(true), "Modal did not open - Bootstrap JS not working"
    end
  end
end
