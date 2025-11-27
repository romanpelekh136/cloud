# frozen_string_literal: true

# spec/retrier_spec.rb
require 'rspec'
require_relative '../retrier'

RSpec.describe Retrier do
  let(:max_attempts) { 3 }
  let(:delay) { 0.1 }

  let(:retrier) do
    described_class.new(max_attempts: max_attempts, delay: delay)
  end

  let(:mock_service) { double('MockService') }

  it 'returns the result on the first attempt if successful' do
    allow(mock_service).to receive(:call).and_return('Success')

    result = retrier.execute { mock_service.call }

    expect(result).to eq('Success')
    expect(mock_service).to have_received(:call).once
  end

  it 'gives up and raises an error after all attempts fail' do
    allow(mock_service).to receive(:call).and_raise(StandardError, 'Service Down!')

    expect do
      retrier.execute { mock_service.call }
    end.to raise_error('Service Down!')

    expect(mock_service).to have_received(:call).exactly(max_attempts).times
  end

  it 'succeeds on the second attempt' do
    expect(mock_service).to receive(:call).once.and_raise(StandardError, 'Service Down!')
    expect(mock_service).to receive(:call).once.and_return('Success')

    result = retrier.execute { mock_service.call }

    expect(result).to eq('Success')
  end
end
