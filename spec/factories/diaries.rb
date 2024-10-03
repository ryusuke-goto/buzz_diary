FactoryBot.define do
  factory :diary do
    sequence(:title) { |n| "title#{n}" }
    body { "aaa" }
    diary_date { Time.zone.today }
    diary_image {"buzz_diary_default_ogp.png"}
    association :user
  end
end
