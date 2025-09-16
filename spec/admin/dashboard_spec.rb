# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :feature do
  let(:admin_user) { AdminUser.create!(email: 'admin@test.com', password: 'password123') }
  
  before do
    # Create test data
    user = create(:user)
    category = create(:category, user: user)
    
    # Create posts with images
    5.times do |i|
      post = create(:post, user: user, title: "Test Post #{i}")
      post.categories << category
      
      # Attach a test image
      post.image.attach(
        io: StringIO.new('test image content'),
        filename: "test_image_#{i}.jpg",
        content_type: 'image/jpeg'
      )
    end
    
    # Login as admin
    visit '/admin/login'
    fill_in 'Email', with: admin_user.email
    fill_in 'Password', with: 'password123'
    click_button 'Login'
  end
  
  it 'displays the last 10 images section' do
    visit '/admin'
    
    expect(page).to have_content('Last 10 images')
    expect(page).to have_css('table')
    
    # Check that we have image columns
    within('table') do
      expect(page).to have_content('Image')
      expect(page).to have_content('Title')
      expect(page).to have_content('User')
      expect(page).to have_content('Categories')
      expect(page).to have_content('Likes')
      expect(page).to have_content('Comments')
      expect(page).to have_content('Created')
    end
  end
  
  it 'shows post titles as links' do
    visit '/admin'
    
    expect(page).to have_link('Test Post 0')
    expect(page).to have_link('Test Post 1')
  end
end
