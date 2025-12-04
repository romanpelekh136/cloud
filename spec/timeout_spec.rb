RSpec.describe Timeout do
  let(:Timeout) { Timeout.new(2) }
  let(:mock_service) { double('Service') }

  # 1. Service runs under wait_time

  # 2. Service does not run under wait_time
end
