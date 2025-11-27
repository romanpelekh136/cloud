class Retrier
  def initialize(max_attempts:, delay:)
    @max_attempts = max_attempts
    @delay = delay
  end

  def execute
    @max_attempts.times do |attempt|
      current_attempt = attempt + 1

      begin
        return yield
      rescue StandardError => e
        if current_attempt >= @max_attempts
          puts "[Retry] All #{@max_attempts} tries failed."
          raise e
        else
          sleep @delay
        end
      end
    end
  end
end
