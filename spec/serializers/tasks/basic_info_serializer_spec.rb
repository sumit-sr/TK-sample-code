# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::BasicInfoSerializer do
  let(:user) { create(:user) }
  # let(:task) { create(:task, created_by: user, updated_by: user) }
  let(:task) { create(:task) }

  describe '#serialize_to_json' do
    subject { described_class.new.serialize(task).deep_symbolize_keys! }

    it {
      is_expected.to eql(
        id: task.id,
        title: task.title,
        details: task.details,
        type_id: task.type_id,
        due_date: task.due_date,
        part_of_day_id: task.part_of_day_id,
        pay_type_id: task.pay_type_id,
        price: task.price,
        hours: task.hours,
        status_id: task.status_id,
        direct_hire: task.direct_hire,
        travel: task.travel,
        other_info: task.other_info,
        offers_count: task.offers_count,
        payment_verified: payment_verified,
        address: address,
        invited: invited,
        created_by: created_by,
        attachments: attachments,
        created_at: task.created_at.strftime(DATE_FORMAT),
        updated_at: task.updated_at.strftime(DATE_FORMAT)
      )
    }

    def address
      return if task.address.blank?

      # Addresses::BasicInfoSerializer.new.serialize(
      #   task.address
      # ).deep_symbolize_keys!
    end

    def attachments
      return [] if task&.attachments.blank?

      task.attachments.map do |attachment|
        Attachments::PropertiesSerializer.new.serialize(
          attachment
        ).deep_symbolize_keys!
      end
    end

    def created_by
      Users::InfoSerializer.new.serialize(task.created_by).deep_symbolize_keys!
    end

    def invited
      return unless invite.present?

      # Tasks::Invites::BasicInfoSerializer.new.serialize(
      #   invite
      # )
    end

    def invite
      @invite ||= task.invites.find_by(tasker_id: user_id)
    end

    def payment_verified
      task.created_by&.profile&.payment_badge
    end

    def user_id
      return unless defined?(context)

      return if context.nil?

      context[:user_id]
    end
  end
end
