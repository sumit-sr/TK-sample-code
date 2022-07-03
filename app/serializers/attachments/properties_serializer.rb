# frozen_string_literal: true

module Attachments
  class PropertiesSerializer < Panko::Serializer
    attributes(
      :id,
      :document_url,
      :medium_url,
      :thumb_url,
      :content_type,
      :document_name,
      :size,
      :primary
    )

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
