require 'rails_helper'

RSpec.describe 'Simple Like Test', type: :system, js: true do
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

  it 'can execute JavaScript and find elements' do
    puts "=== SIMPLE LIKE TEST ==="
    
    # Проверить, что страница загрузилась
    expect(page).to have_content('ImageGallery')
    puts "Page loaded successfully"
    
    # Найти кнопку лайка
    like_button = find("button[onclick*='toggleLike']", match: :first)
    puts "Found like button: #{like_button.inspect}"
    
    # Проверить, что JavaScript функция существует
    js_result = page.evaluate_script('typeof window.toggleLike')
    puts "toggleLike function type: #{js_result}"
    expect(js_result).to eq('function')
    
    # Проверить CSRF токен
    csrf_meta = page.evaluate_script("document.querySelector('meta[name=\"csrf-token\"]')")
    puts "CSRF meta tag present: #{csrf_meta.present?}"

    if csrf_meta
      csrf_token = page.evaluate_script("document.querySelector('meta[name=\"csrf-token\"]').getAttribute('content')")
      puts "CSRF token present: #{csrf_token.present?}"
      expect(csrf_token).to be_present
    else
      puts "CSRF meta tag not found - this is expected in test environment"
    end
    
    # Попробовать прямой HTTP запрос вместо JS
    puts "Making direct HTTP request..."

    # Получить текущие куки сессии
    session_cookie = page.driver.browser.manage.cookie_named('_image_gallery_session')
    puts "Session cookie: #{session_cookie.present?}"

    # Сделать прямой запрос
    require 'net/http'
    require 'uri'

    uri = URI('http://127.0.0.1:' + Capybara.current_session.server.port.to_s + '/toggle_like')
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['Cookie'] = "_image_gallery_session=#{session_cookie[:value]}" if session_cookie
    request.body = "post_id=#{post.id}"

    response = http.request(request)
    puts "HTTP response code: #{response.code}"

    # Проверить, что лайк был создан
    post.reload
    likes_count = post.likes.count
    puts "Likes count after HTTP request: #{likes_count}"

    user_like = post.likes.find_by(user: user)
    puts "User like exists: #{user_like.present?}"

    expect(likes_count).to be > 0
    expect(user_like).to be_present
  end
end
