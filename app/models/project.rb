# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks

  scope :search, ->(query) { where('title LIKE ? OR description LIKE ? ', "%#{query}%", "%#{query}%") }
end
