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
      if possible_full_names.one?
        unless Rails.env.test?
          pubs1 = author.journals.limit(10).pluck(:name).uniq.inspect
          pubsy1 = author.publications.order("RANDOM()").limit(10).pluck(:publication_year).inspect
          pubst1 = author.publications.order("RANDOM()").limit(2).pluck(:title).inspect
          pubs2 = possibility.journals.limit(10).pluck(:name).uniq.inspect
          pubsy2 = possibility.publications.order("RANDOM()").limit(10).pluck(:publication_year).inspect
          pubst2 = possibility.publications.order("RANDOM()").limit(2).pluck(:title).inspect
          match_score = AuthorMatcher.new(author).match_score(possibility)
          puts pubs1
          puts ":" .sp pubsy1
          puts ">" .sp pubst1
          puts "-------"
          puts pubs2
          puts ":" .sp pubsy2
          puts ">" .sp pubst2
          puts match_score
          puts author.name .sp author.id.to_s .sp " => " .sp possibility.name .sp possibility.id.to_s
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