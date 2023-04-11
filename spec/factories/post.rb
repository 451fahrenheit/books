FactoryBot.define do
  factory :post do
    title{ Faker::Lorem.word }
    subtitle{ Faker::Lorem.word }
    excerpt{ Faker::Lorem.word }
    content{ Faker::Lorem.word }
  end
end
