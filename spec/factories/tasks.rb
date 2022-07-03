# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Long Title with at least 10 characters' }
    # created_by_id { create(:user).id }
    # updated_by_id { create(:user).id }
    association :created_by, factory: :user
    association :updated_by, factory: :user
    # zip_code

    trait :open do
      status_id { 1 }
    end
  end
end
