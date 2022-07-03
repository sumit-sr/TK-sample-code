# frozen_string_literal: true

class Attachment < ApplicationRecord
  has_many :associations_attachments, dependent: :destroy
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User', optional: true

  attr_accessor :from_file_upload, :current_user
end
