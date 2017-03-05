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

  task seed_categories: :environment do
    Journal.find_by(name: "Linguistics and Philosophy").update_attributes(categorization: {"pl" => "100"})
    Journal.find_by(name: "Semiotica").update_attributes(categorization: {"pl" => "100"})
    Journal.find_by(name: "Journal of Consciousness Studies").update_attributes(categorization: {"pm" => "100"})
    Journal.find_by("name LIKE '%Language'").update_attributes(categorization: {"pm" => "30", "cs"=> "30", "pl" => "40"})
    Journal.find_by(name: "Review of Metaphysics").update_attributes(categorization: {"mt" => "100"})
    Journal.find_by(name: "Synthese").update_attributes(categorization: {"mt" => "50", em: "50"})
    Journal.find_by(name: "Analysis").update_attributes(categorization: {"mt" => "50", em: "50"})
    Journal.find_by(name: "Erkenntnis").update_attributes(categorization: {"mt" => "50", em: "50"})
    Journal.find_by(name: "Australasian Journal of Philosophy").update_attributes(categorization: {"mt" => "33", em: "33", "pl" => "33"})
    Journal.find_by(name: "Episteme: Journal of Social Epistemology").update_attributes(categorization: {"em" => "100"})
    Journal.find_by(name: "Journal of Symbolic Logic").update_attributes(categorization: {"lo" => "100"})
    Journal.find_by(name: "Journal of Philosophical Logic").update_attributes(categorization: {"lo" => "100"})
    Journal.find_by(name: "British Journal for the Philosophy of Science").update_attributes(categorization: {"ps" => "100"})
    Journal.find_by(name: "Biology and Philosophy").update_attributes(categorization: {"ps" => "100"})
    Journal.find_by(name: "Ethics").update_attributes(categorization: {"et" => "100"})
    Journal.find_by(name: "Ethical Theory and Moral Practice").update_attributes(categorization: {"et" => "100"})
    Journal.find_by(name: "Journal of Ethics").update_attributes(categorization: {"et" => "100"})
    Journal.find_by(name: "Behavioral and Brain Sciences").update_attributes(categorization: {"cs" => "80", 'pm' => "20"})
    Journal.find_by(name: "Theory and Decision").update_attributes(categorization: {"fo" => "100"})
    Journal.find_by(name: "Political Theory").update_attributes(categorization: {"po" => "100"})
    Journal.find_by(name: "Law and Philosophy").update_attributes(categorization: {"lp" => "100"})
    Journal.find_by(name: "Bioethics").update_attributes(categorization: {"me" => "100"})
    Journal.find_by(name: "Business Ethics Quarterly").update_attributes(categorization: {"be" => "100"})
    Journal.find_by(name: "British Journal of Aesthetics").update_attributes(categorization: {"pa" => "100"})
    Journal.find_by(name: "Hypatia").update_attributes(categorization: {"fp" => "100"})
    Journal.find_by(name: "Apeiron").update_attributes(categorization: {"ap" => "100"})
    Journal.find_by(name: "Asian Philosophy").update_attributes(categorization: {"as" => "100"})
    Journal.find_by(name: "Hume Studies").update_attributes(categorization: {"mp" => "100"})
    Journal.find_by(name: "British Journal for the History of Philosophy").update_attributes(categorization: {"mp" => "100"})
    Journal.find_by(name: "History of Philosophy Quarterly").update_attributes(categorization: {"mp" => "100"})
    Journal.find_by(name: "Russell: Journal of Bertrand Russell Archives").update_attributes(categorization: {"ha" => "100"})
    Journal.find_by(name: "Religious Studies").update_attributes(categorization: {"pr" => "100"})
    Journal.find_by(name: "Bulletin of the Hegel Society of Great Britain").update_attributes(categorization: {"cl" => "20", "mp" => "80"})
    Journal.find_by(name: "Continental Philosophy Review").update_attributes(categorization: {"cp" => "100"})
    Journal.find_by(name: "Heidegger Studies").update_attributes(categorization: {"cp" => "100"})
    Publication.where("title LIKE ?", "%Essence%").update_all(categorization: {"mt" => "100"})
    Publication.where("title LIKE ?", "%Universals%").update_all(categorization: {"mt" => "100"})
    Publication.where("title LIKE ?", "%Grounding%").update_all(categorization: {"mt" => "100"})
    Publication.where("title LIKE ?", "%Existence%").update_all(categorization: {"mt" => "100"})
    Publication.where("title LIKE ?", "%Abstact Objects%").update_all(categorization: {"mt" => "100"})
    Publication.where("title LIKE ?", "%Knowledge%").update_all(categorization: {"em" => "100"})
    Publication.where("title LIKE ?", "%Belief%").update_all(categorization: {"em" => "100"})
    Publication.where("title LIKE ?", "%Probability%").update_all(categorization: {"em" => "100"})
    Publication.where("title LIKE ?", "%Evidence%").update_all(categorization: {"em" => "100"})
    Publication.where("title LIKE ?", "%Justification%").update_all(categorization: {"em" => "100"})
    Publication.where("title LIKE ?", "%Consequentialism%").update_all(categorization: {"et" => "100"})
    Publication.where("title LIKE ?", "%Deontology%").update_all(categorization: {"et" => "100"})
    Publication.where("title LIKE ?", "%Conditionals%").update_all(categorization: {"pl" => "100"})
    Publication.where("title LIKE ?", "%Predicates%").update_all(categorization: {"pl" => "100"})
    Publication.where("title LIKE ?", "%Names%").update_all(categorization: {"pl" => "100"})
    Publication.where("title LIKE ?", "%Sleeping Beauty%").update_all(categorization: {"fo" => "100"})
    Publication.where("title LIKE ?", "%Bayesianism%").update_all(categorization: {"fo" => "100"})
    Publication.where("title LIKE ?", "%Decision Theory%").update_all(categorization: {"fo" => "100"})
    Publication.where("title LIKE ?", "%Wittgenstein%").update_all(categorization: {"ha" => "100"})
    Publication.where("title LIKE ?", "%Frege%").update_all(categorization: {"ha" => "100"})
    Publication.where("title LIKE ?", "%Descartes%").update_all(categorization: {"mp" => "100"})
    Publication.where("title LIKE ?", "%Spinoza%").update_all(categorization: {"mp" => "100"})
    Publication.where("title LIKE ?", "%Medieval%").update_all(categorization: {"mp" => "100"})
    Publication.where("title LIKE ?", "%Feminist%").update_all(categorization: {"fp" => "100"})
    Publication.where("title LIKE ?", "%Abortion%").update_all(categorization: {"me" => "100"})
    Publication.where("title LIKE ?", "%Qualia%").update_all(categorization: {"pm" => "100"})
    Publication.where("title LIKE ?", "%Consciousness%").update_all(categorization: {"pm" => "100"})
    Publication.where("title LIKE ?", "%Knowledge Argument%").update_all(categorization: {"pm" => "100"})
    Publication.where("title LIKE ?", "%Introspection%").update_all(categorization: {"pm" => "100"})
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
    Journal.find_each do |journal|
      CategoryReconciler.reconcile_journal_with_pubs(journal)
      print ">"
    end
  end
end