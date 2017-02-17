class AuthorCleaner
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
end