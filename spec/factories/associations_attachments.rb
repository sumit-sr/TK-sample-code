# frozen_string_literal: true

FactoryBot.define do
  factory :associations_attachment do
    attachable_type { 'User' }
    attachable_id { 1 }
    attachment_id { 1 }
  end
end
