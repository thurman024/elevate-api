FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    session_token { nil }
    games_played { 0 }

    trait :with_session do
      session_token { SecureRandom.hex(20) }
    end

    trait :with_games do
      games_played { rand(1..100) }
    end
  end
end
