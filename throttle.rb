class Throttle 
  def initialize(wait_time)
    @wait_time = wait_time
    @is_closed = false
    @closing_time = nil
  end

  def execute 
    if @is_closed == true && Time.now - @closing_time >= @wait_timed
        @is_closed = false
      else
        return
      end   
    end

    @closing_time = Time.now
    @is_closed = true
    yield
  end
end
