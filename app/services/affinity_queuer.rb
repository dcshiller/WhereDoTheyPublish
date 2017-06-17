class AffinityQueuer

  def self.queue_all
    Journal.ids.each { |id| Resque.enqueue(AffinityCalculator, id) }
  end

end