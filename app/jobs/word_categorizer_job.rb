class WordCategorizerJob
    @queue = :queue

  def self.perform(words, average)
    words.each do |word|
      CategoryReconciler.reconcile_pubs_by_title_word(word, average)
    end
  end
end