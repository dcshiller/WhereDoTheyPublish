class AuthorCategorizerJob
    @queue = :queue

  def self.perform(author_ids, average)
    Author.find(author_ids).each do |author|
      CategoryReconciler.reconcile_pubs_with_author(author, average)
    end

    Author.find(author_ids).each do |author|
      CategoryReconciler.reconcile_author_with_pubs(author, average)
    end
  end
end