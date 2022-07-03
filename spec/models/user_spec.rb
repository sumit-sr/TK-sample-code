# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  context 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('not-an-email').for(:email) }

    describe 'when there are invalid attributes' do
      let(:invalid_attributes) { {} }
      let(:user) { User.create(invalid_attributes) }

      describe '#valid?' do
        subject { user.valid? }

        it { is_expected.to be(false) }
      end

      describe '#persisted?' do
        subject { user.persisted? }

        it { is_expected.to be(false) }
      end
    end
  end

  context 'Associations' do
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_many(:earnings) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_many(:tasks) }
  end

  context 'Functions' do
    context '#full_name' do
      it 'consist of first and last name' do
        # add code to do test case for function full_name in user.rb model
        #         @user = FactoryBot.create(:user)
        #         user = [@user.first_name, @user.last_name]
        #                .join(' ').gsub(/\s+/, ' ').strip.titleize
        #         expect(@user.full_name). to eq(user)
      end
    end
  end

  # context 'FactoryBot' do
  #   let(:user) { create(:user) }
  #   let(:tasker) { create(:tasker) }

  #   it 'can create a user factory' do
  #     expect(user.valid?).to be(true)
  #   end

  #   context 'make offers' do
  #     let(:user) { create(:user, :with_complete_profile) }

  #     it 'can create a user factory that can make offers' do
  #       expect(user.can_make_offer?).to be(true)
  #     end
  #   end

  #   context 'profile photo' do
  #     let(:user) { create(:user, :with_profile_photo) }

  #     it 'can create a user factory that has a profile photo' do
  #       expect(user.profile_photo?).to be(true)
  #     end
  #   end

  #   context 'billing address' do
  #     let(:user) { create(:user, :with_billing_address) }

  #     it 'can create a user factory that has a billing address' do
  #       expect(user.billing_address?).to be(true)
  #     end
  #   end

  #   context 'cell connection' do
  #     let(:user) { create(:user, :with_cell) }

  #     it 'can create a user factory with a cell number' do
  #       expect(user.cell?). to be(true)
  #     end
  #   end

  #   it 'can create a tasker factory' do
  #     expect(tasker.valid?).to be(true)
  #   end

  #   it 'can create tasker with the role tasker' do
  #     expect(tasker.roles.first.name).to eq('tasker')
  #   end

  #   it 'can create more than one tasker factory' do
  #     expect(create_list(:tasker, 2).length).to be(2)
  #   end

  #   context 'tasker with assigned tasks' do
  #     let(:tasker) { create(:tasker, :with_assigned_tasks) }
  #     subject { tasker.assigned_tasks }

  #     it 'has assigned tasks' do
  #       expect(subject.count).to eq(3)
  #     end

  #     it 'has a completed tasks' do
  #       expect(subject.completed.count).to eq(1)
  #     end
  #   end

  #   context 'with_addresses' do
  #     subject { create(:user, :with_addresses) }

  #     it 'creates three addresses for user' do
  #       expect(subject.addresses.count).to eq(3)
  #     end

  #     it 'has one default address' do
  #       expect(subject.addresses.where(default: true).count).to eq(1)
  #     end
  #   end
  # end

  # describe '#default_address' do
  #   let(:user) { create(:user, :with_addresses, addresses_count: 1) }
  #   let(:default_address) { user.addresses.first }
  #   it 'returns the default address' do
  #     expect(user.default_address).to eq(default_address)
  #   end
  # end

  # context 'CallBacks' do
  #   it { is_expected.to callback(:set_address).after(:create) }
  #   it {
  #     is_expected.to callback(:add_as_payment_gateway_customer).after(:create)
  #   }
  #   it { is_expected.to callback(:verify_profile).before(:update) }
  # end
end
