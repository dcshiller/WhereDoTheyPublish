
class String
  raise 'error, method already defined' if "a".respond_to?(:sp)
  def sp(other_string)
    "#{self} #{other_string}"
  end

  def proper_titlecase
    string = self.titlecase.strip
    non_capped = %w[ a an the at by for in of on to up and as but or nor et de van von ]
    non_capped.each do |word|
      string.gsub! " #{word.titlecase} ", " #{word.downcase} "
    end
    string[0] = string[0].upcase
    string
  end
end
