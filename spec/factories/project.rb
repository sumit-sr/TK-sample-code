# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'Project title' }
    description { 'Project description' }
    user
  end
end
