# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let(:user) { create(:user) }
  let(:path) { '/projects' }
  let(:params) { {} }
  let(:headers) { {} }
  let(:title) { 'title' }
  let(:description) { Faker::Lorem.sentence }

  let(:params_data) do
    {
      title: title,
      description: description
    }
  end

  before(:example) do
    post(path, params: params_data, headers: headers).to_json
  end

  describe '#create' do
    it_behaves_like('handles missing credentials')

    context 'when user credentials are provided' do
      let(:params) { params_data }

      include_context 'when user credentials are provided'

      context 'when there are invalid params' do
        %w[title description].each do |f_name|
          context "when #{f_name} is blank" do
            let(f_name.to_sym) { '' }

            it_behaves_like(
              INVALID_PARAMS, ["Parameter #{f_name} cannot be blank"]
            )
          end
        end
      end

      context 'when all params are valid' do
        it_behaves_like('201 response status')

        it 'returns correct response' do
          response_data = JSON.parse(response.body).deep_symbolize_keys!

          expect(response_data).to eql(
            { status: 'project added successfully.' }
          )
        end
      end
    end
  end
end
