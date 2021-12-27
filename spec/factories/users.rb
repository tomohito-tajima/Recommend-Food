FactoryBot.define do
  factory :user do
    # name { Faker::Name }
    # email { Faker::Internet.free_email }
    # password = Faker::Internet.password(min_length: 6)
    # encrypted_password { password }
    name {"hiro"}
    sequence(:email) { |n| "hiro#{n}@example.com"}
    password {"password"}
  end
end
