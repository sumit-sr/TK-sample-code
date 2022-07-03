# frozen_string_literal: true

module Projects
  class ShowSerializer < Panko::Serializer
    attributes(
      :id,
      :title,
      :description,
      :start_date,
      :end_date,
      :im_not_sure,
      :estimated_budget,
      :total_spent,
      :user,
      :completed_task,
      :active_task,
      :in_progress_task,
      :created_at,
      :updated_at
    )

    def user
      # Users::BasicInfoSerializer.new(
      #   context: { access_token: access_token }
      # ).serialize(object.user)
      Users::InfoSerializer.new.serialize(object.user)
    end

    def access_token
      return unless defined?(context)

      return if context.nil?

      context[:access_token]
    end

    def completed_task
      object.tasks.completed.count
    end

    def active_task
      object.tasks.open.count
    end

    def in_progress_task
      object.tasks.in_progress.count
    end

    def total_spent
      # object.tasks.collect(&:earnings).compact.collect(&:total_amount).count
    end
  end
end
