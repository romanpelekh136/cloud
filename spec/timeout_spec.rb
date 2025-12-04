require 'rspec' # rubocop:disable Style/FrozenStringLiteralComment
require_relative '../timeout'

RSpec.describe Timeout do
  let(:timeout) { Timeout.new(0.5) }

  it 'the service executes under wait_time' do
    result = timeout.execute { 'Success' }
    expect(result).to eq('Success')
  end

  it 'the service does not executes under wait_time' do
    expect do
      timeout.execute do
        sleep 1
        'Success'
      end
    end.to raise_error(TimeOutError)
  end
end
