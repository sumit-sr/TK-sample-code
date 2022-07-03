# frozen_string_literal: true

require 'csv'

namespace :category do
  desc 'Load categories and subcategories'
  task load: :environment do
    Category.load_data
  end

  desc 'Update categories and subcategories'
  task load_category_type: :environment do
    Category.update_data_type
  end

  desc 'Load categories and filters'
  task load_category_filter_and_options: :environment do
    Category.load_new_categories
  end
end
