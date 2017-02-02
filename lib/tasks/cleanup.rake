namespace :cleanup do
  task remove_nil_authors: :environment do
    NilDeleter.delete!
  end
end
