# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::ShowSerializer do
  let(:project) { create(:project) }

  describe '#serialize_to_json' do
    subject { described_class.new.serialize(project).deep_symbolize_keys! }

    it {
      is_expected.to eql(
        id: project.id,
        title: project.title,
        description: project.description,
        start_date: project.start_date,
        end_date: project.end_date,
        im_not_sure: project.im_not_sure,
        estimated_budget: project.estimated_budget,
        total_spent: total_spent,
        user: user,
        completed_task: completed_task,
        active_task: active_task,
        in_progress_task: in_progress_task,
        created_at: project.created_at.strftime(DATE_FORMAT),
        updated_at: project.updated_at.strftime(DATE_FORMAT)
      )
    }
  end

  def user
    Users::InfoSerializer.new.serialize(project.user).deep_symbolize_keys!
    # Users::BasicInfoSerializer.new(
    #   context: { access_token: access_token }
    # ).serialize(object.user)
    # Users::BasicInfoSerializer.new(
  end

  def completed_task
    project.tasks.completed.count
  end

  def active_task
    project.tasks.open.count
  end

  def in_progress_task
    project.tasks.in_progress.count
  end

  def total_spent; end
end
