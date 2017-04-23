class AuthorCleaner
  ACCENTED_CHARACTERS = %w[á Á é É í Í ó Ó ú Ú ý Ý ä Ä ë Ë ï Ï ö Ö ü Ü à À è È ì Ì ò Ò ù Ù ã Ã ñ Ñ õ Õ ç Ç].
                        in_groups_of 2
  
  def self.remove_non_first_accented_caps!
    ACCENTED_CHARACTERS.each do |(lc, uc)|
      [:first_name, :middle_initial, :last_name].each do |name|
        Author.where("#{name} LIKE '%#{uc}%'").find_each do |author|
          current_names = author.send(name).split(" ")
          current_names.map! do |current_name|
            current_initial = current_name[0]
            current_initial + current_name[1..-1].gsub(uc, lc)
          end
            new_name = current_names.join(" ")
            author.update_attributes(name => new_name)
        end
        dups = Author.where(first_name: author.reload.first_name, middle_initial: author.middle_initial, last_name: author.last_name)
        if dups.count > 1
          dups[1].merge_into dups[0]
        end
      end
    end
  end

  def self.clean_all!
    delete_nils!
    delete_with_no_pubs!
    space_initials!
    move_initials_to_middle!
  end

  def self.delete_nils!
    blank_authors = Author.where(first_name: ["", nil], last_name: ["",nil], middle_initial: ["",nil])
    blank_authors.each do |ba|
      ba.authorships.each do |baa|
        baa.destroy
        print "." unless Rails.env.test?
      end
      ba.destroy
      print ":" unless Rails.env.test?
    end
  end

  def self.delete_with_no_pubs!
    Author.where.not(id: Author.distinct.joins(:publications).pluck(:id)).destroy_all
  end

  def self.space_initials!
    authors = Author.where("first_name LIKE '_._.' OR first_name LIKE '_._._.'")
    authors.each do |author|
      first_name = author.first_name
      new_first_name = first_name.gsub(".",". ").gsub("  "," ").strip
      dup_author = Author.find_by(first_name: new_first_name, middle_initial: author.middle_initial, last_name: author.last_name)
      if dup_author
        author.merge_into(dup_author)
      else
        print first_name + " => "
        author.first_name = new_first_name
        puts new_first_name
        author.save
        puts author.name
      end
    end

    authors = Author.where("middle_initial LIKE '_._.' OR middle_initial LIKE '_._._.'")
    authors.each do |author|
      middle_initial = author.middle_initial
      new_middle_initial = middle_initial.gsub(".",". ").gsub("  "," ").strip
      dup_author = Author.find_by(first_name: author.first_name, middle_initial: new_middle_initial, last_name: author.last_name)
      if dup_author
        author.merge_into(dup_author)
      else
        print middle_initial + " => "
        author.middle_initial = new_middle_initial
        puts new_middle_initial
        author.save
        puts author.name
      end
    end
  end

  def self.move_initials_to_middle!
    authors = Author.where("first_name LIKE '% %'")
    authors.each do |author|
      first_name = author.first_name
      middle_initial = author.middle_initial
      new_first_name, additional_initials = first_name.split(" ")[0], first_name.split(" ")[1..-1].join(" ")
      new_middle_initials = middle_initial.blank? ? additional_initials : (additional_initials .sp middle_initial)
      dup_author = Author.find_by(first_name: new_first_name, middle_initial: new_middle_initials, last_name: author.last_name)
      if dup_author
        author.merge_into dup_author
      else
        author.update_attributes(first_name: new_first_name, middle_initial: new_middle_initials)
      end
    end
  end
end