require 'rspec'
require_relative '../retrier'

RSpec.describe Retrier do
  let(:delay) { 0.5 }

  let(:max_attempts) { 3 }

  let(:mock_service) {double('MockService')}

  let(:retrier) { described_class.new(max_attempts: max_attempts ,delay: delay) }

  



end