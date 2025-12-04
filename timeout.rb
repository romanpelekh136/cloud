class TimeOutError < StandardError

class Timeout
  def initialize(wait_time)
    @wait_time = wait_time
  end

  def execute(&block)
    worker = Thread.new(&block)
    check = worker.join(@wait_time)

    return worker.value unless check.nil?

    worker.kill

    raise TimeOutError, 'Execution expired'
  end
end
