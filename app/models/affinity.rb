class Affinity < ActiveRecord::Base
  belongs_to :journal_one, class_name: "Journal", foreign_key: 'first_journal_id', dependent: :destroy
  belongs_to :journal_two, class_name: "Journal", foreign_key: 'second_journal_id', dependent: :destroy

  def self.calculate_affinity(journal_one, journal_two)
    return if journal_two.name <= journal_one.name
    affinity = Affinity.find_or_create_by(journal_one: journal_one, journal_two: journal_two)
    return if affinity.affinity && affinity.updated_at > 1.day.ago
    affinity_rating = journal_one.co_publication_percentage(journal_two)
    affinity.update_attributes(affinity: affinity_rating)
  end

  def self.for(journal_one, journal_two = nil)
    if journal_two.nil?
      Affinity.where(journal_one: journal_one).or(Affinity.where(journal_two: journal_one))
    elsif journal_one.name <= journal_two.name
      Affinity.where(journal_one: journal_one, journal_two: journal_two)
    else
      Affinity.where(journal_one: journal_two, journal_two: journal_one)
    end
  end
end