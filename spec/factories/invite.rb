# frozen_string_literal: true

FactoryBot.define do
  factory :invite do
    association :task
    association :tasker
    association :user
  end
end
