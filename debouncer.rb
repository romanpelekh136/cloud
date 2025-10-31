# frozen_string_literal: true

class Debouncer
  def initialize(wait_time)
    @wait_time = wait_time
    @timer_thread = nil
    @mutex = Mutex.new
  end

  def execute
    @mutex.synchronize do
      @timer_thread.kill if @timer_thread&.alive?

      @timer_thread = Thread.new do
        sleep @wait_time

        yield
      end
    end
  end
end
