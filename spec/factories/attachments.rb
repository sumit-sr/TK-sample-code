# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    document_file_name { 'Xemox' }
    document_content_type { 'image/jpeg' }
    slug { SecureRandom.urlsafe_base64(nil, false) }
  end
end
