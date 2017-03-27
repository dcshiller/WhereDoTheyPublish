class CategoryReconciler
  def self.shift(cato, from_cat, to_cat)
    from_cat_val = cato.cat[from_cat]
    subtraction_amount = from_cat_val / 3
    cato.categorization[from_cat] = (from_cat_val - subtraction_amount).to_s
    to_cat_val = cato.cat[to_cat]
    cato.categorization[to_cat] = (to_cat_val + subtraction_amount).to_s
    cato.save
  end

  def self.reconcile_journal_with_pubs(journal, average = {})
    pubs = journal.publications.articles
    normalized_average_values = normalize get_average(pubs)
    reconcile(journal, normalized_average_values, average)
  end

  def self.reconcile_author_with_pubs(author, average = {})
    pubs = author.publications.articles
    normalized_average_values = normalize get_average(pubs)
    reconcile(author, normalized_average_values, average)
  end

  def self.reconcile_pubs_with_journal(journal, average = {})
    return if journal.cat.blank?
    pubs = journal.publications.articles
    pubs.each do |pub|
      reconcile(pub, journal.cat, average)
    end
  end

  def self.reconcile_pubs_with_author(author, average = {})
    return if author.cat.blank?
    pubs = author.publications.articles
    pubs.each do |pub|
      reconcile(pub, author.cat, average)
    end
  end

  def self.reconcile_pubs_by_title_word(word, average = {})
    word = word.split("'")[0]
    pubs = Publication.articles.where("COALESCE(title, display_title) LIKE '%#{word}%'")
    normalized_average_values = normalize get_average(pubs)
    return if average? normalized_average_values, average
    pubs.each do |pub|
      reconcile(pub, normalized_average_values, average)
    end
  end

  def self.get_average(categorizables)
    cat_count = categorizables.count
    categorizables.inject(Hash.new(0)) do |accum, pub|
      pub.cat.each do |k, v|
        accum[k] = accum[k] + v
      end
      accum
    end.map { |k, v| [k, v / cat_count] }
  end

  def self.get_average_hash(categorizables)
    Hash[ get_average(categorizables) ]
  end

  def self.average?(hash, average)
    hash.all? { |k,v| v.to_i < average[k].to_i + 3 }
  end

  private

  def self.reconcile(reconcilee, values, average = {})
    new_values = Hash.new(0)
    reconcilee.cat.each do |k,v|
      new_values[k] = Math.sqrt(v**2 + (((values[k] || 0) - (average[k] || 0))**2))
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
    Hash[values.map { |k,v| [k, ((v * 100) / sum).to_i] }]
  end
end