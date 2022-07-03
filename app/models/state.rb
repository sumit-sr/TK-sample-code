# frozen_string_literal: true

class State < ApplicationRecord
  belongs_to :country
  has_many :cities, dependent: :destroy
  has_many :zip_codes, through: :cities

  validates :name, presence: true
  has_many :counties, dependent: :destroy
end
