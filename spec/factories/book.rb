FactoryBot.define do
  factory :book do
    volumeId  { Faker::Lorem.word }
    title{ Faker::Lorem.word }
    subtitle{ Faker::Lorem.word }
    description{ Faker::Lorem.word }
    authors{ Faker::Lorem.word }
    language{ Faker::Lorem.word }
    pubDate{ Faker::Lorem.word }
    smallthumbnail{ Faker::Lorem.word }
    thumbnail { Faker::Lorem.word }
  end
end