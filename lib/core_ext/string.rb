
class String
  raise 'error, method already defined' if "a".respond_to?(:sp)
  def sp(other_string)
    "#{self} #{other_string}"
  end
end