# frozen_string_literal: true

FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    prefix { Faker::Address.state_abbr }
    country
  end
end
