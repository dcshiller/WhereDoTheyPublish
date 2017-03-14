class CategorizerJob
    @queue = :queue

  def self.perform
    Resque::Worker.new(queue: :queue).startup
    average = CategoryReconciler.get_average_hash(Publication.order("RANDOM()").limit(10000))
    
    Journal.find_each do |journal|
      CategoryReconciler.reconcile_pubs_with_journal(journal, average)
      print "."
    end
    Author.find_each do |author|
      CategoryReconciler.reconcile_author_with_pubs(author, average)
      print "!"
      CategoryReconciler.reconcile_pubs_with_author(author, average)
      print "+"
    end
    words = File.readlines("data/title_words").map(&:chomp)
    words.each do |word|
      CategoryReconciler.reconcile_pubs_by_title_word(word, average)
      print "w"
    end
    Journal.find_each do |journal|
      CategoryReconciler.reconcile_journal_with_pubs(journal, average)
      print ">"
    end
  end
end