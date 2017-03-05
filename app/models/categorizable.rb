module Categorizable
  def cat
    Hash[categorization.map{ |k,v| [k, v.to_i] }]
  end

  def cat=(value)
    self.categorization = Hash[ value.map { |k,v| [k, v.to_s] } ]
  end
end