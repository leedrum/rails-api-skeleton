# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    password {"Aa@123456"}
  end
end
