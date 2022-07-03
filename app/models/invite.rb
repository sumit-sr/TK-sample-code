# frozen_string_literal: true

class Invite < ApplicationRecord
  belongs_to :task
  belongs_to :user
  belongs_to :tasker, class_name: 'User',
                      foreign_key: :tasker_id
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :comment, -> { order('created_at ASC') }, as: :commentable,
                                                    class_name: 'Comment'

  INVALID_VALIDATION = 'Invite has already been sent to this tasker.'

  validates_uniqueness_of :task_id, allow_blank: true,
                                    scope: %i[user_id tasker_id],
                                    message: INVALID_VALIDATION

  enum status: %i[pending accepted declined]
  scope :for_user, ->(user_id) { where(tasker_id: user_id) }
end
