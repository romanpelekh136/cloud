class Throttle # rubocop:disable Style/FrozenStringLiteralComment
  def initialize(wait_time)
    @wait_time = wait_time
    @closing_time = Time.now - @wait_time
  end

  def execute
    return if Time.now - @closing_time < @wait_time

    yield
    @closing_time = Time.now
  end
end
