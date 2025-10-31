require 'rspec'
require_relative '../retrier'

RSpec.describe Retrier do
  let(:delay) { 0.1 }

  let(:max_attempts) { 3 }

  let(:mock_service) {double('MockService')}

  let(:retrier) { described_class.new(max_attempts: max_attempts ,delay: delay) }

  it 'success fro, first try' do
    allow(mock_service).to receive(:call).and_return("Success")

    result = retrier.execute { mock_service.call }
    expect(result).to eq("Success")
    expect(mock_service).to have_received(:call).once
  end



end