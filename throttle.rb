class Throttle # rubocop:disable Style/FrozenStringLiteralComment,Style/Documentation
  def initialize(wait_time)
    @wait_time = wait_time
    @closing_time = Time.at(0)
  end

  def execute
    @current_time = Time.now
    return if @current_time - @closing_time < @wait_time

    @closing_time = @current_time

    yield
  end
end
