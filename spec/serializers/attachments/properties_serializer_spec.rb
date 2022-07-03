# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachments::PropertiesSerializer do
  let(:attachment) { create(:attachment) }

  describe '#serialize_to_json' do
    subject { described_class.new.serialize(attachment).deep_symbolize_keys! }

    it {
      is_expected.to eql(
        id: attachment.id,
        document_url: document_url,
        medium_url: medium_url,
        thumb_url: thumb_url,
        content_type: content_type,
        document_name: document_name,
        size: size,
        primary: attachment.primary
      )
    }

    def document_url
      # object.document_url
    end

    def medium_url
      # object.medium_url
    end

    def thumb_url
      # object.thumb_url
    end

    def content_type
      # object.content_type
    end

    def document_name
      # object.document_name
    end

    def size
      # object.document_file_size
    end
  end
end
