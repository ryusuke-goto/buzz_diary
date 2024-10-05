FactoryBot.define do
  factory :comment do
    body { "aaa" }
    association :user
    association :diary
  end
end