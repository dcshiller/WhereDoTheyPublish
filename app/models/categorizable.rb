module Categorizable

  def category_name
    {
      pl: "Philosophy of Language",
      pm: "Philosophy of Mind",
      mt: "Metaphysics",
      em: "Epistemology",
      cs: "Cognitive Science",
      lo: "Logic",
      ps: "Philosophy of Science",
      pb: "Philosophy of Biology",
      et: "Ethics",
      fo: "Formal Philosophy",
      po: "Political Philosophy",
      lp: "Philosophy of Law",
      md: "Medieval Philosophy",
      me: "Medical Ethics",
      pa: "Aesthetics",
      ap: "Ancient Philosophy",
      as: "Asian Philosophy",
      mp: "Modern Philosophy",
      ha: "History of Analytic",
      pr: "Philosophy of Religion",
      cp: "Continental Philosophy",
      be: "Business Ethics"
    }.with_indifferent_access
  end

  def cat
    @cat ||= Hash[categorization.map{ |k,v| [k, v.to_i] }]
  end

  def cat=(value)
    self.categorization = Hash[ value.map { |k,v| [k, v.to_s] } ]
  end

  def primary_category
    cat.to_a.sort{|a,b| a[1] <=> b[1] }.last[0]
  end

  def primary_category_name
    category_name[primary_category]
  end
end