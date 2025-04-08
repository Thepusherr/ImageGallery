FactoryBot.define do
  factory :category do
    name { "Sample Category" }
    user
    visibility { :visible }
    
    trait :hidden do
      visibility { :hidden }
    end
  end
end
