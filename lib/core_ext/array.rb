class Array
  def longest
    sort! { |x,y| x.length <=> y.length }.last
  end
end
