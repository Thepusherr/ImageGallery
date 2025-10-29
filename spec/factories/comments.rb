# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    text { 'Test Comment' }
    user
    post
  end
end
