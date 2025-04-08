FactoryBot.define do
  factory :comment do
    text { 'Test Comment' }
    user
    post
  end
end