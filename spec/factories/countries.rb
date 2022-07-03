# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    alpha2 { Faker::Address.country_code }
  end
end
