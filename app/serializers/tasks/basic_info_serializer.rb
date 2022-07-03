# frozen_string_literal: true

module Tasks
  class BasicInfoSerializer < Panko::Serializer
    attributes(
      :id,
      :title,
      :details,
      :type_id,
      :due_date,
      :part_of_day_id,
      :pay_type_id,
      :price,
      :hours,
      :status_id,
      :direct_hire,
      :travel,
      :other_info,
      :offers_count,
      :payment_verified,
      :address,
      :invited,
      :created_by,
      :attachments,
      :created_at,
      :updated_at
    )

    has_many :attachments, each_serializer: Attachments::PropertiesSerializer

    def created_by
      # Users::BasicInfoSerializer.new(
      #   context: { access_token: access_token }
      # ).serialize(object.project.user)
      Users::InfoSerializer.new.serialize(object.created_by)
    end

    def address
      return if object.address.blank?

      Addresses::BasicInfoSerializer.new.serialize(
        object.address
      )
    end

    def invited
      # return unless invite.present?

      # Tasks::Invites::BasicInfoSerializer.new.serialize(
      #   invite
      # )
    end

    def invite
      # @invite ||= object.invites.find_by(tasker_id: user_id)
    end

    def payment_verified
      object.created_by&.profile&.payment_badge
    end

    def user_id
      return unless defined?(context)

      return if context.nil?

      context[:user_id]
    end

    def access_token
      return unless defined?(context)

      return if context.nil?

      context[:access_token]
    end
  end
end
