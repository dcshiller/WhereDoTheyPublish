class ClearerJob
  @queue = :queue
  include Categories

  def self.perform(step)
    initial_settings
  end

  def self.initial_settings
    average = CATEGORIES.keys.map { |k| [k, 5] }.to_h
    Journal.update_all(categorization: average)
    Author.update_all(categorization: average)
    Publication.update_all(categorization: average)
  end
end