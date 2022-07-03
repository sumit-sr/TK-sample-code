# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Time.now }
    dob { Faker::Date.birthday }

    tag_line { 'Tag line' }
    about_you { 'About you' }
    customer_id { 129_146_229 }

    trait :with_addresses do
      transient do
        addresses_count { 3 }
      end

      after(:create) do |user, evaluator|
        user.addresses = create_list(
          :address,
          evaluator.addresses_count,
          addressable: user,
          default: false
        )

        user.addresses.first.default = true
        user.addresses.first.save!
      end
    end

    trait :with_profile_photo do
      after(:create) do |user|
        Attachment.add_attachment(user, '')
      end
    end

    trait :with_cell do
      after(:create) do |user|
        user.connections.create!(attributes_for(:connection))
      end
    end

    trait :with_billing_address do
      after(:create) do |user|
        create(:bank_account, user: user, status: 'active', primary: true)
      end
    end

    trait :with_complete_profile do
      with_addresses
      with_profile_photo
      with_cell
      with_billing_address
    end

    factory :tasker do
      after :create do |tasker|
        tasker.update(earn_money: true)
      end

      trait :with_assigned_tasks do
        transient do
          num_tasks { 3 }
          completed { 1 }
        end

        after(:create) do |tasker, evaluator|
          create_list(:task, evaluator.num_tasks)
          Task.where(assigned_to: nil).each do |task|
            task.assigned_to_id = tasker.id
            task.save!
          end

          evaluator.completed.times do |i|
            tasker.assigned_tasks[i].completed!
          end
        end
      end

      trait :with_complete_profile do
        with_addresses
        with_profile_photo
        with_cell
        with_billing_address
      end
    end

    factory :poster do
      after :create do |poster|
        create(:roles_user, role: create(:poster_role), user: poster)
      end

      trait :with_assigned_tasks do
        transient do
          num_tasks { 3 }
          completed { 1 }
        end

        after(:create) do |poster, evaluator|
          create_list(:task, evaluator.num_tasks)
          Task.where(assigned_to: nil).each do |task|
            task.assigned_to_id = poster.id
            task.save!
          end

          evaluator.completed.times do |i|
            poster.assigned_tasks[i].completed!
          end
        end
      end
    end

    factory :support do
      after :create do |support|
        create(:roles_user, role: create(:support_role), user: support)
      end
    end

    trait :poster do
      association :attachment
      association :bank_account

      after(:create) do |user|
        create(:connection, :cell, :verified, user_id: user.id)
      end
    end
  end
end
