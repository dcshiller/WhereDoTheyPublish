class AffinityCalculator
    @queue = :queue

  def self.perform(journal_id)
    journal = Journal.find(journal_id)
    Journal.find_each do |j|
      Affinity.calculate_affinity(journal, j)
    end
  end
end
