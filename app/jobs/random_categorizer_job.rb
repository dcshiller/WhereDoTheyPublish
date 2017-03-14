class RandomCategorizerJob
    @queue = :queue

  def self.perform
    time = Time.now
    words = File.readlines("data/title_words").map(&:chomp)
    average = CategoryReconciler.get_average_hash(Publication.order("RANDOM()").limit(10000))
    until Time.now > time + 5.minutes
      number = rand(100)
      if number < 3
        journal = Journal.order("RANDOM()").first
        CategoryReconciler.reconcile_pubs_with_journal(journal, average)
        CategoryReconciler.reconcile_journal_with_pubs(journal, average)
      elsif number < 70
        author = Author.order("RANDOM()").first
        CategoryReconciler.reconcile_author_with_pubs(author, average)
        CategoryReconciler.reconcile_pubs_with_author(author, average)
      else
        word = words.sample
        CategoryReconciler.reconcile_pubs_by_title_word(word, average)
      end
    end
  end
end