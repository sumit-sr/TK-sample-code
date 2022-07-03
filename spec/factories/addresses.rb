# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    name { %w[Home Mailing Business].sample }
    address_line { Faker::Address.unique.street_address }
    default { true }
    zip_code

    trait :for_user do
      association :addressable, factory: :user
    end

    trait :for_bank_account do
      association :addressable, factory: :bank_account
    end
  end
end
