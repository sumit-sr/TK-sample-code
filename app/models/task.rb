# frozen_string_literal: true

class Task < ApplicationRecord
  ORDER = { created_at: :desc }.freeze

  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id,
                          required: true
  belongs_to :updated_by, class_name: 'User', foreign_key: :updated_by_id,
                          required: true
  belongs_to :assigned_to, class_name: 'User', foreign_key: :assigned_to_id,
                           optional: true
  belongs_to :cancelled_by, class_name: 'User', foreign_key: :cancelled_by_id,
                            optional: true
  belongs_to :project, optional: true

  has_many :payments
  has_many :offers, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :associations_attachments, as: :attachable, dependent: :destroy
  has_many :attachments, through: :associations_attachments
  has_many :invites

  enum status_id: %i[draft open completed cancel under_review assigned
                     partially_done payment_processed incomplete review_task
                     in_dispute in_progress auto_cancel]

  scope :under_progress, -> { where(status_id: INPROGRESS_STATUSES) }

  INPROGRESS_STATUSES = %w[assigned under_review incomplete partially_done
                           review_task in_progress].freeze

  def accepted_offer
    offers.where(accepted: true, user_id: assigned_to_id)&.last
  end

  # def budget
  #   total_budget || accepted_offer&.amount
  # end

  # def total_budget
  #   pay_type_id == 'hourly' ? price * hours : price
  # end

  class << self
    def max_assigned
      group(:assigned_to_id).count(:assigned_to_id).values.max
    end
  end
end
