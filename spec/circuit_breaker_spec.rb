# frozen_string_literal: true

require 'rspec'

require_relative '../circuit_breaker'

RSpec.describe CircuitBreaker do
  let(:failure_threshold) { 2 }
  let(:recovery_timeout) { 1 }

  let(:breaker) do
    described_class.new(
      failure_threshold: failure_threshold,
      recovery_timeout: recovery_timeout
    )
  end

  let(:mock_service) { double('MockService') }

  it 'circuit become :open after :failure_threshold limit' do
    allow(mock_service).to receive(:call).and_raise(StandardError, 'Service is Down!')

    expect do
      breaker.execute { mock_service.call }
    end.to raise_error('Service is Down!')

    expect(breaker.state).to eq(:closed)

    expect do
      breaker.execute { mock_service.call }
    end.to raise_error('Service is Down!')

    expect(breaker.state).to eq(:open)
  end

  it 'immediately raises CircuitBreakerError when state is :open' do
    allow(mock_service).to receive(:call).and_raise(StandardError, 'Service is Down!')

    2.times do
      expect { breaker.execute { mock_service.call } }.to raise_error('Service is Down!')
    end

    expect(breaker.state).to eq(:open)

    expect { breaker.execute { mock_service.call } }.to raise_error(CircuitBreakerError)
  end

  it 'goes to :half_open after timeout and to :closed if success' do
    allow(mock_service).to receive(:call).and_raise(StandardError, 'Service is Down!')

    2.times do
      expect { breaker.execute { mock_service.call } }.to raise_error('Service is Down!')
    end

    expect(breaker.state).to eq(:open)

    future_time = Time.now + recovery_timeout + 0.1
    allow(Time).to receive(:now).and_return(future_time)

    allow(mock_service).to receive(:call).and_return('Recovered!')

    result = breaker.execute { mock_service.call }

    expect(result).to eq('Recovered!')
    expect(breaker.state).to eq(:closed)
  end
end
