require 'rails_helper'

RSpec.describe 'Posts Interaction', type: :system, js: true do
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
    
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    
    visit root_path
  end

  describe 'Like functionality' do
    it 'allows user to like and unlike a post' do
      puts "=== TESTING LIKE FUNCTIONALITY ==="
      
      like_button = find("button[id*='likeBtn']", match: :first)
      puts "Found like button: #{like_button.inspect}"
      
      heart_icon = like_button.find('i')
      initial_classes = heart_icon[:class]
      puts "Initial heart icon classes: #{initial_classes}"
      
      puts "Clicking like button..."
      like_button.click
      
      sleep 2
      
      current_url_after_click = current_url
      puts "URL after like click: #{current_url_after_click}"
      
      like_button_after = find("button[id*='likeBtn']", match: :first)
      heart_icon_after = like_button_after.find('i')
      final_classes = heart_icon_after[:class]
      puts "Final heart icon classes: #{final_classes}"

      post.reload
      likes_count = post.likes.count
      puts "Likes count in database: #{likes_count}"

      user_like = post.likes.find_by(user: user)
      puts "User like exists: #{user_like.present?}"
      
      expect(likes_count).to be > 0
      expect(user_like).to be_present
    end
  end

  describe 'Comment functionality' do
    it 'allows user to create a comment' do
      skip 'System test requires proper UI elements and browser setup'
      puts "=== TESTING COMMENT FUNCTIONALITY ==="

      comment_button = find("a[data-bs-target*='commentsModal']", match: :first)
      puts "Found comment button: #{comment_button.inspect}"
      
      comment_button.click
      
      sleep 1
      
      comment_form = find('form[action*="/comments"]', match: :first)
      puts "Found comment form: #{comment_form.inspect}"
      
      comment_text = "Test comment from integration test"
      text_field = comment_form.find('input[name="text"]')
      text_field.fill_in(with: comment_text)
      puts "Filled comment text: #{comment_text}"
      
      submit_button = comment_form.find('input[type="submit"]')
      puts "Clicking submit button..."
      submit_button.click
      
      sleep 3
      
      current_url_after_submit = current_url
      puts "URL after comment submit: #{current_url_after_submit}"
      
      post.reload
      comments_count = post.comments.count
      puts "Comments count in database: #{comments_count}"
      
      created_comment = post.comments.find_by(text: comment_text, user: user)
      puts "Created comment exists: #{created_comment.present?}"
      
      if created_comment
        puts "Created comment text: #{created_comment.text}"
        puts "Created comment user: #{created_comment.user.email}"
      end
      
      expect(comments_count).to be > 0
      expect(created_comment).to be_present
      expect(created_comment.text).to eq(comment_text)
    end
  end

  describe 'Page behavior' do
    it 'checks for JavaScript errors and console logs' do
      skip 'System test requires proper UI elements and browser setup'
      puts "=== CHECKING PAGE BEHAVIOR ==="

      expect(page).to have_content('ImageGallery')
      
      logs = page.driver.browser.logs.get(:browser)
      puts "Browser console logs:"
      logs.each do |log|
        puts "  #{log.level}: #{log.message}"
      end
      
      error_logs = logs.select { |log| log.level == 'SEVERE' }
      if error_logs.any?
        puts "SEVERE JavaScript errors found:"
        error_logs.each { |log| puts "  #{log.message}" }
      end
      
      expect(error_logs).to be_empty, "JavaScript errors found: #{error_logs.map(&:message)}"
    end
  end
end
