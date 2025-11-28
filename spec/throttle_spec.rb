require 'rspec' # rubocop:disable Style/FrozenStringLiteralComment
require_relative '../throttle'

RSpec.describe Throttle do
  let(:throttle) { Throttle.new(0.5) }
  let(:mock_service) { double('Service') }

  it 'the first req executes before closing throttle' do
    expect(mock_service).to receive(:call).once

    throttle.execute { mock_service.call }
  end

  it 'the second req doesnt execute after closing' do
    expect(mock_service).to receive(:action1).once
    expect(mock_service).to receive(:action2).never

    start_time = Time.now

    allow(Time).to receive(:now).and_return(start_time, start_time + 0.1)

    throttle.execute { mock_service.action1 }
    throttle.execute { mock_service.action2 }
  end

  it 'second execution after wait time' do
    expect(mock_service).to receive(:action1).twice
    start_time = Time.now

    allow(Time).to receive(:now).and_return(start_time, start_time + 1)
    throttle.execute { mock_service.action1 }
    throttle.execute { mock_service.action1 }
  end
end
