class Retrier

  def initialize(max_attempts:, delay:)
    @max_attempts = max_attempts
    @delay = delay
  end

  def execute
    @max_attempts.times do |attempt|
      begin
        return yield
      rescue 
        
      end
      
    end
  end

end
