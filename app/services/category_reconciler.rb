class CategoryReconciler
  def self.reconcile_journal_with_pubs(journal)
    pubs = journal.publications.articles
    normalized_average_values = normalize get_average(pubs)
    reconcile(journal, normalized_average_values)
  end

  def self.reconcile_author_with_pubs(author)
    pubs = author.publications.articles
    normalized_average_values = normalize get_average(pubs)
    reconcile(author, normalized_average_values)
  end

  def self.reconcile_pubs_with_journal(journal)
    return if journal.cat.blank?
    pubs = journal.publications.articles
    pubs.each do |pub|
      reconcile(pub, journal.cat)
    end
  end

  def self.reconcile_pubs_with_author(author)
    return if author.cat.blank?
    pubs = author.publications.articles
    pubs.each do |pub|
      reconcile(pub, author.cat)
    end
  end

  def self.reconcile_pubs_by_title_word(word)
    pubs = Publication.articles.where("COALESCE(title, display_title) LIKE '%#{word}%'")
    normalized_average_values = normalize get_average(pubs)
    pubs.each do |pub|
      reconcile(pub, normalized_average_values)
    end
  end

  private

  def self.get_average(categorizables)
    categorizables.inject(Hash.new(0)) do |accum, pub|
      pub.cat.each do |k,v|
        accum[k] = accum[k] + v
      end
      accum
    end.map { |k, v| [k, v / categorizables.count] }
  end

  def self.reconcile(reconcilee, values)
    new_values = Hash.new(0)
    reconcilee.cat.each do |k,v|
      new_values[k] = Math.sqrt(v.to_i**2 + (values[k].to_i)**2)
    end
    (values.keys - reconcilee.cat.keys).each do |k|
      new_values[k] = values[k]
    end
    reconcilee.cat = normalize new_values
    reconcilee.save
  end

  def self.normalize(values)
    sum = values.inject(0) { |sum, (_, v)| sum + v }
    return {} unless sum > 0
    Hash[values.map { |k,v| [k, ((v*100)/sum).to_i] }]
  end
end