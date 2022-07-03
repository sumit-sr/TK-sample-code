# frozen_string_literal: true

FactoryBot.define do
  factory :zip_code do
    code { Faker::Address.zip_code }
    city
  end
end
