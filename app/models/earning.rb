# frozen_string_literal: true

class Earning < ApplicationRecord
  def self.max_earned
    group(:user_id).sum(:total_amount).values.max
  end
end
