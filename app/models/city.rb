# frozen_string_literal: true

class City < ApplicationRecord
  belongs_to :state

  has_many :zip_codes, dependent: :destroy
end
