# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseResponse do
  let(:subject) { described_class.new }

  let(:some_errors) { ['some error'] }

  describe '#errors' do
    it 'is initialized as an empty array' do
      expect(subject.errors).to eql([])
    end

    it 'can have errors concatenated to it' do
      subject.errors.concat(some_errors)

      expect(subject.errors).to eql(some_errors)
    end
  end

  context 'when there are no errors' do
    let(:success_hash) { { worked: true } }

    before(:example) do
      allow(subject).to receive(:success_hash).and_return(success_hash)
    end

    describe '#errors' do
      it 'returns []' do
        expect(subject.errors).to eql([])
      end
    end

    describe '#valid?' do
      it 'returns true' do
        expect(subject.valid?).to be(true)
      end
    end

    describe '#status' do
      it 'returns :ok' do
        expect(subject.status).to eql(:ok)
      end
    end

    describe '#response' do
      it 'returns a hash with status: and json: success_hash' do
        expect(subject.response).to eql(
          status: :ok,
          json: success_hash
        )
      end
    end

    describe '#to_h' do
      it 'returns success_hash' do
        expect(subject.to_h).to eql(success_hash)
      end
    end
  end

  context 'when there are errors' do
    let(:expected_errors_hash) { { errors: some_errors } }

    before(:example) do
      subject.errors.concat(some_errors)
    end

    describe '#errors' do
      it 'returns the array of errors' do
        expect(subject.errors).to eql(some_errors)
      end
    end

    describe '#valid?' do
      it 'returns false' do
        expect(subject.valid?).to be(false)
      end
    end

    describe '#status' do
      it 'returns :bad_request' do
        expect(subject.status).to eql(:bad_request)
      end
    end

    describe '#response' do
      it 'returns a hash with status: and json: error_hash' do
        expect(subject.response).to eql(
          status: :bad_request,
          json: expected_errors_hash
        )
      end
    end

    describe '#to_h' do
      it 'returns error_hash' do
        expect(subject.to_h).to eql(expected_errors_hash)
      end
    end
  end
end
