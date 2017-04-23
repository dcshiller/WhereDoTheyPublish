module Categorizable

  def category_name
    {
      pl: "Language",
      pm: "Mind",
      mt: "Metaphysics",
      em: "Epistemology",
      lo: "Logic",
      ps: "Science",
      et: "Ethics",
      po: "Politics and Law",
      pa: "Aesthetics",
      ap: "Ancient",
      as: "Asian",
      ae: "Applied Ethics",
      mp: "Modern",
      pr: "Religion"
    }.with_indifferent_access
  end

  def starting_cat
    {
      "pl" => "4",
      "pm" => "4",
      "mt" => "4",
      "em" => "4",
      "lo" => "4",
      "ps" => "4",
      "et" => "4",
      "po" => "4",
      "pa" => "4",
      "ap" => "4",
      "as" => "4",
      "ae" => "4",
      "mp" => "4",
      "pr" => "4"
    }
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
