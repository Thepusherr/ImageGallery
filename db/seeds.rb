# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin = AdminUser.create!(email: 'admin@example.com', password: '123123', password_confirmation: '123123') if Rails.env.development? 

# image = File.open(Rails.root.join('db/seeds/micropost_placeholder.png'))
# image.rewind

#user2.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')), filename: 'default-avatar.png') 

user1 = User.new(name: 'John', surname: 'Jons', email: 'spunkspunkik@gmail.com', password: '123123', password_confirmation: '123123')
user1.avatar = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
user1.save!
#user1.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')), filename: 'default-avatar.png') 

# File.open(File.join(Rails.root,'app/assets/images/default-avatar.png'))
user2 = User.new(name: 'Bert', surname: 'Berner', email: 'spunkspunkik2@gmail.com', password: '123123', password_confirmation: '123123')
user2.avatar = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
user2.save!
# Create posts
post1 = Post.new(title: 'Beautiful sunset', text: 'This is my first post!', user_id: user1.id)
post1.image = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
post1.save!

post2 = Post.new(title: 'Mountain view', text: 'Amazing mountains!', user_id: user1.id)
post2.image = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
post2.save!

post3 = Post.new(title: 'Delicious pasta', text: 'Homemade pasta recipe', user_id: user2.id)
post3.image = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
post3.save!

post4 = Post.new(title: 'City skyline', text: 'Beautiful architecture', user_id: user1.id)
post4.image = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
post4.save!

post5 = Post.new(title: 'Portrait photography', text: 'My latest portrait session', user_id: user2.id)
post5.image = File.open(Rails.root.join('app/assets/images/default-avatar.png'))
post5.save!

# Create comments
Comment.create!(text: 'Nice photo!', post_id: post1.id, user_id: user2.id)
Comment.create!(text: 'Beautiful!', post_id: post1.id, user_id: user1.id)
Comment.create!(text: 'Great shot!', post_id: post2.id, user_id: user2.id)
Comment.create!(text: 'Looks delicious!', post_id: post3.id, user_id: user1.id)
Comment.create!(text: 'Amazing architecture!', post_id: post4.id, user_id: user2.id)

# Create likes
Like.create!(user_id: user1.id, post_id: post1.id)
Like.create!(user_id: user2.id, post_id: post1.id)
Like.create!(user_id: user1.id, post_id: post3.id)
Like.create!(user_id: user2.id, post_id: post2.id)
Like.create!(user_id: user1.id, post_id: post5.id)
# Create categories
category1 = Category.create!(name: 'Nature', user_id: user1.id)
category2 = Category.create!(name: 'Travel', user_id: user1.id)
category3 = Category.create!(name: 'Food', user_id: user2.id)
category4 = Category.create!(name: 'Portraits', user_id: user2.id)
category5 = Category.create!(name: 'Architecture', user_id: user1.id)

# Associate posts with categories
post1.categories << category1
post1.categories << category2
post1.save!

post2.categories << category1
post2.categories << category2
post2.save!

post3.categories << category3
post3.save!

post4.categories << category5
post4.save!

post5.categories << category4
post5.save!
