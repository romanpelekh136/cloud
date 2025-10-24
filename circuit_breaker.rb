class CircuitBreakerError < StandardError; end

class CircuitBreaker
  attr_reader :state

  def initialize(failure_threshold:, recovery_timeout:)
    @failure_threshold = failure_threshold
    @recovery_timeout = recovery_timeout

    @state = :closed
    @failure_count = 0
    @last_failure_time = nil
  end

  def execute
    case @state
    when :closed
      handle_closed_state { yield }
    when :open
      handle_open_state { yield }
    when :half_open
      handle_half_open_state { yield }
    end
  end

  private

  def reset
    change_state(:closed)
    @failure_count = 0
    @last_failure_time = nil
  end

  def record_failure
    @failure_count += 1
    if @failure_count >= @failure_threshold
      trip
    end
  end

  def trip
    change_state(:open)

    @last_failure_time = Time.now
  end

  def change_state(new_state)
    unless @state == new_state
      puts "[CircuitBreaker] Стан: #{@state} -> #{new_state}"
      @state = new_state
    end
  end



  def handle_closed_state
    begin
      result = yield
      reset; result
    rescue StandardError => e
      record_failure; raise e
    end
  end

  def handle_open_state
    if Time.now - @last_failure_time >= @recovery_timeout
      change_state(:half_open)
      handle_half_open_state { yield }
    else
      raise CircuitBreakerError, "Circuit is OPEN. Fast-failing."
    end
  end

  def handle_half_open_state
    begin
      result = yield
      reset; result
    rescue StandardError => e
      trip; raise e
    end
  end
end