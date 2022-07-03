# frozen_string_literal: true

namespace :data do
  namespace :education_degrees do
    desc 'Persists education degrees to db'
    task load: :environment do
      degree_names = Rails.root.join('data/education_degrees.txt')

      File.foreach(degree_names) do |degree_name|
        EducationDegree.where('name ILIKE ?', degree_name.strip)
                       .first_or_create(name: degree_name.strip)
      end
    end
  end
end
