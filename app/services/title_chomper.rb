class TitleChomper
  def self.chomp!
    period_ending_pubs = Publication.where("title LIKE '%.' AND NOT title like '%...'")
                                    .or(Publication.where("display_title LIKE '%.' AND NOT display_title LIKE '%...'"))
    period_ending_pubs.each do |pub|
      if pub.display_title
        pub.display_title = pub.display_title.chomp(".")
      else
        pub.display_title = pub.title.chomp(".")
      end
      pub.save
      print "."
    end
  end
end