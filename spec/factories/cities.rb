# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    state
  end
end
