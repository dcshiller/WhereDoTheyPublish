class AuthorCleaner
  def self.delete_nils!
    blank_authors = Author.where(first_name: nil, last_name: nil, middle_initial: nil)
    blank_authors.each do |ba|
      ba.authorships.each do |baa|
        baa.destroy
        print "." unless Rails.env.test?
      end
      ba.destroy
      print ":" unless Rails.env.test?
    end
  end
end