# frozen_string_literal: true

# for RSpec use ApplicationRecord
# class User < ApplicationRecord
class User < KaargarUser
  attr_accessor :master_user

  ORDER_BY = 'created_at DESC'
  self.primary_key = 'master_user_id' # comment for RSpec

  has_secure_password # we can remove this after with integrating common user

  has_one :profile, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :earnings
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assigned_to_id
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :tasks, foreign_key: :created_by_id
  has_many :offers, dependent: :destroy

  after_create :set_profile

  enum deactivate_reason: AppConfig['deactivate_reason']

  # Require only for RSpec
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: { case_sensitive: false }
  # validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def set_profile
    return if profile.present?

    build_profile.save
  end

  def tasker_checks
    # master_user_id
    { id: id, profile_photo: profile.profile_pic_badge,
      account_details: profile.bank_detail_badge, cell: profile.telephone_badge }
  end
  # We are also checking for dob, but I guess we don't require that now.

  def poster_checks
    # master_user_id
    { id: id, profile_photo: profile.profile_pic_badge,
      payment_method: profile.payment_badge, cell: profile.telephone_badge }
  end

  def can_make_offer?
    profile.profile_pic_badge && profile.bank_detail_badge && profile.telephone_badge
  end

  def can_accept_offer?
    profile.profile_pic_badge && profile.payment_badge && profile.telephone_badge
  end

  def dob; end

  def dob?; end

  def poster?
    get_things_done
  end

  def tasker?
    earn_money
  end

  def fetch_tier
    ServiceFeeType.where('service_fee_types.to > ?', calculate_earnings).first
  end

  def calculate_earnings
    return 0 if earnings.blank?

    earnings_30_days
  end

  def earnings_30_days
    earnings.where(
      'earnings.created_at >= ? AND earnings.created_at <= ?',
      last_30_days, time_zone_datetime
    ).sum(:total_amount)
  end

  def time_zone_datetime
    Time.now.in_time_zone(user_time_zone).end_of_day
  end

  def last_30_days
    time_zone_datetime - 30.days
  end

  def profile_pic
    # attachment&.document_url
  end

  def profile_pic_alt
    "#{first_name&.first}#{last_name&.first}"&.upcase
  end

  def verify_profile
    self.verified_as_tasker = can_make_offer? if tasker?
    self.verified_as_poster = can_accept_offer? if poster?
  end
end
