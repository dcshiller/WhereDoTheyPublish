class CategorizerJob
  @queue = :queue

  def self.perform
    Resque::Worker.new(queue: 'queue').startup
    Author.first.update_attributes(first_name: "BIOII")
    Journal.find_each do |journal|
      CategoryReconciler.reconcile_pubs_with_journal(journal)
      print "."
    end
    Author.find_each do |author|
      CategoryReconciler.reconcile_author_with_pubs(author)
      print "!"
      CategoryReconciler.reconcile_pubs_with_author(author)
      print "+"
    end
    words = TitleDistillator.get_words
    words.each do |word|
      CategoryReconciler.reconcile_pubs_by_title_word(word)
      print "w"
    end
    Journal.find_each do |journal|
      CategoryReconciler.reconcile_journal_with_pubs(journal)
      print ">"
    end
  end
end