# frozen_string_literal: true

class ZipCode < ApplicationRecord
  belongs_to :city

  delegate :state, to: :city
  delegate :country, to: :state

  def full_name
    "#{code}, #{city.try(:name)}, #{state.try(:name)}, #{country.try(:name)}"
  end
end
