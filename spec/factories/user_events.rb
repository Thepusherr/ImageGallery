FactoryBot.define do
  factory :user_event do
    user
    action_type { 'login' }
    url { 'http://example.com' }
  end
end
