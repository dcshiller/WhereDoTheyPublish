class Affinity < ActiveRecord::Base
  belongs_to :journal_one, class_name: "Journal", foreign_key: 'first_journal_id'
  belongs_to :journal_two, class_name: "Journal", foreign_key: 'second_journal_id'

  def self.calculate_affinity(journal_one, journal_two)
    unless Affinity.where(journal_one: [journal_one, journal_two], journal_two: [journal_one, journal_two]).
                    where("first_journal_id != second_journal_id").exists?
      return if journal_one == journal_two
      affinity = Affinity.create(journal_one: journal_one, journal_two: journal_two)
      affinity_rating = journal_one.co_publication_percentage(journal_two)
      affinity.update_attributes(affinity: affinity_rating)
    end
  end

  def self.for(journal_one, journal_two = nil)
    if journal_two.nil?
      Journal.all.map { |j| Affinity.for(journal_one, j) }
    else
      (Affinity.where(journal_one: journal_one, journal_two: journal_two) || 
        Affinity.where(journal_one: journal_two, journal_two: journal_one)).first
    end
  end
end