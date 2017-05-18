namespace :analyze do
  task calculate_affinities: :environment do
    Journal.find_each do |journal_one|
      return unless Affinity.where(journal_one: journal_one).where.not(affinity: nil).count >= Journal.count - 1
      Journal.find_each do |journal_two|
        Affinity.calculate_affinity(journal_one, journal_two)
        print("-")
      end
    end
  end


  task random_categorize: :environment do
    time = Time.now
    words = TitleDistillator.get_words
    until Time.now > time + 5.minutes
      number = rand(100)
      if number < 2
        journal = Journal.order("RANDOM()").first
        CategoryReconciler.reconcile_pubs_with_journal(journal)
        CategoryReconciler.reconcile_journal_with_pubs(journal)
      elsif number < 70
        author = Author.order("RANDOM()").first
        CategoryReconciler.reconcile_author_with_pubs(author)
        CategoryReconciler.reconcile_pubs_with_author(author)
      else
        word = words.sample
        CategoryReconciler.reconcile_pubs_by_title_word(word)
      end
      print "."
    end
  end

  task categorize: :environment do
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