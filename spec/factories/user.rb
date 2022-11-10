FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password_digest {'Alph@jack'}
    end
end