class Future
  def initialize(&block)
    @worker = Thread.new(&block)
  end

  def get_result
    @worker.value
  end
end
