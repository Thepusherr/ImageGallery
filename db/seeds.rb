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

user1 = User.create!(name: 'John', surname: 'Jons', email: 'spunkspunkik@gmail.com', password: '123123', password_confirmation: '123123')
user1.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')), filename: 'default-avatar.png') 
# File.open(File.join(Rails.root,'app/assets/images/default-avatar.png'))
user2 = User.create!(name: 'Bert', surname: 'Berner', email: 'spunkspunkik2@gmail.com', password: '123123', password_confirmation: '123123')
user2.avatar.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')), filename: 'default-avatar.png') 
post1 = Post.create!(title: 'My photo', text: '', user_id: user1.id)
post1.image.attach(io: File.open(Rails.root.join('app/assets/images/default-avatar.png')) , filename: 'default-avatar.png') 
Comment.create!(text: 'Nice photo!', post_id: post1.id, user_id: user2.id)
Comment.create!(text: 'Beautiful!', post_id: post1.id, user_id: user1.id)
Like.create(user_id: user1.id, post_id: post1.id)
Like.create(user_id: user2.id, post_id: post1.id)