# frozen_string_literal: true

module Addresses
  class BasicInfoSerializer < Panko::Serializer
    attributes(
      :city,
      :state,
      :country,
      :address_line,
      :zip_code,
      :coordinates
    )

    def coordinates
      { latitude: object.latitude, longitude: object.longitude }
    end

    def zip_code
      zipcode&.code
    end

    def zipcode
      @zipcode ||= ZipCode.find_by(id: object.zip_code_id)
    end
  end
end
