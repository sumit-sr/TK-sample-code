# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  context 'Associations' do
    it do
      is_expected.to belong_to(:created_by).class_name('User')
                                           .with_foreign_key('created_by_id')
                                           .required
    end
    it do
      is_expected.to belong_to(:updated_by).class_name('User')
                                           .with_foreign_key('updated_by_id')
                                           .required
    end
  end
  #   it { is_expected.to belong_to(:zip_code).optional }

  #   it { is_expected.to have_one(:auto_canceled) }
  #   it { is_expected.to have_one(:dispute_ticket) }

  #   it { is_expected.to have_many(:offers).dependent(:destroy) }
  #   it { is_expected.to have_many(:payments) }
  #   it { is_expected.to have_many(:payment_requests) }
  #   it { is_expected.to have_many(:reports) }
  #   it { is_expected.to have_many(:followers) }
  #   it { is_expected.to have_many(:questions) }
  #   it do
  #     is_expected.to have_many(:associations_attachments).dependent(:destroy)
  #   end
  #   it do
  #     is_expected.to have_many(:attachments).through(:associations_attachments)
  #   end
  #   it { is_expected.to have_many(:reviews) }
  #   it { is_expected.to have_many(:payment_requests) }
  #   it { is_expected.to have_many(:activities) }
  #   it { is_expected.to have_many(:categories_tasks).dependent(:destroy) }
  #   it { is_expected.to have_many(:categories).through(:categories_tasks) }
  #   it { is_expected.to have_many(:invoices) }
  #   it { is_expected.to have_many(:comments).dependent(:destroy) }
  #   it { is_expected.to have_many(:status_workflows) }
  # end

  # context 'Validations' do
  #   it { is_expected.to validate_presence_of(:title) }
  #   it do
  #     is_expected.to validate_length_of(:title).is_at_least(10).is_at_most(50)
  #   end
  #   # it { is_expected.to validate_presence_of(:created_at) }
  #   # it { is_expected.to validate_presence_of(:updated_at) }
  # end

  # context 'Enums' do
  #   it do
  #     is_expected.to define_enum_for(:pay_type_id).with_values(%i[fixed hourly])
  #   end
  #   it do
  #     is_expected.to define_enum_for(:type_id).with_values(%i[in_person remotely])
  #   end
  #   it do
  #     is_expected.to define_enum_for(:part_of_day_id).with_values(%i[morning midday
  #                                                                    afternoon evening])
  #   end
  #   it {
  #     is_expected.to define_enum_for(:status_id).with_values(
  #       %i[
  #         step_1 open completed step_2 cancel under_review assigned partially_done
  #         payment_processed incomplete review_task in_dispute in_progress auto_cancel
  #         draft
  #       ]
  #     )
  #   }
  # end

  # describe '#accepted_offer' do
  #   context 'when a task does not have an accepted offer' do
  #     subject { create(:task) }

  #     it 'returns nil' do
  #       expect(subject.accepted_offer).to be nil
  #     end
  #   end

  #   context 'when a task has an accepted offer' do
  #     subject { create(:task, assigned_to_id: user.id) }
  #     let(:user) { create(:user) }

  #     it 'returns the accepted offer' do
  #       offer = create(:offer, accepted: true, task: subject, user_id: user.id)

  #       expect(subject.accepted_offer).to eq(offer)
  #     end
  #   end
  # end

  context 'FactoryBot' do
    let(:task) { create(:task) }

    it 'can create a task factory' do
      expect(task.valid?).to be(true)
    end
  end
end
