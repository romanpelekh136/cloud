require 'rspec'

require_relative '../future'

RSpec.describe Future do
  it 'executes the block and returns the value' do
    task = described_class.new { 10 + 20 }
    result = task.get_result
    expect(result).to eq(30)
  end

  it 'runs multiple tasks in parallel' do
    start_time = Time.now
    task1 = described_class.new do
      sleep 0.5
      'A'
    end
    task2 = described_class.new do
      sleep 0.5
      'B'
    end

    task1.get_result
    task2.get_result

    end_time = Time.now
    total_time = end_time - start_time
    expect(total_time).to be < 1
  end
end
