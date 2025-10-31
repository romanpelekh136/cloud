# frozen_string_literal: true

require 'rspec'
require_relative '../debouncer'

RSpec.describe Debouncer do
  let(:mock_service) { double('MockService') }

  let(:wait_time) { 0.1 }

  let(:debouncer) { described_class.new(wait_time) }

  it 'execute one time after wait time' do
    expect(mock_service).to receive(:call).once

    debouncer.execute { mock_service.call }

    sleep wait_time + 0.05
  end

  it 'execute only last req if requests are too frequent' do
    expect(mock_service).to receive(:action1).never
    expect(mock_service).to receive(:action2).once

    debouncer.execute { mock_service.action1 }

    sleep wait_time / 2

    debouncer.execute { mock_service.action2 }

    sleep wait_time + 0.05
  end
end
