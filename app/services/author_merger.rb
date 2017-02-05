class AuthorMerger
  def self.merge!
    authors = match("first_name") | match("middle_initial")
    authors.each do |author|
      matcher_1 = author.first_name.split(".").map {|m| m.strip}
      matcher_2 = author.middle_initial.split(".").map {|m| m.strip}
      matcher_3 = author.last_name
      possible_full_names = Author.where("first_name LIKE '#{matcher_1.join("% ")}%'") 
                                  .where("middle_initial LIKE '#{matcher_2.join("% ")}%'") 
                                  .where(last_name: matcher_3) - [author]
      possibility = possible_full_names.first
      if possible_full_names.one? && author.publication_consistent?(possibility)
        unless Rails.env.test?
          puts author.name .sp " => " .sp possible_full_names.first.name
          print "confirm? "
          merge_confirm = gets.chomp
          puts "#{merge_confirm }\n"
        else
          merge_confirm = "y"
        end
        author.merge_into(possible_full_names.first) if merge_confirm == "y"
      end
    end
  end

  def self.match(field)
    Author.where("#{field} LIKE '_.' OR
                  #{field} LIKE '_' OR
                  #{field} LIKE '_._.' OR
                  #{field} LIKE '_. _.' OR
                  #{field} LIKE '_ _' OR
                  #{field} LIKE '_._._.' OR
                  #{field} LIKE '_ _ _' OR
                  #{field} LIKE '_. _. _.'").
          to_a
  end
end