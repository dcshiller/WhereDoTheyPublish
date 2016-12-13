# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

journal_list = {
                 economics: File.read("#{Rails.root}/db/economics_journal_names.txt").split("\n"),
                 history: File.read("#{Rails.root}/db/history_journal_names.txt").split("\n"),
                 philosophy: File.read("#{Rails.root}/db/philosophy_journal_names.txt").split("\n"),
                 psychology: File.read("#{Rails.root}/db/psychology_journal_names.txt").split("\n")
               }

journals = []
journal_list.each do |category, list|
  list.each do |entry|
    if journals.any? {|j| j.name == entry}
      journals.each {|j| j.send("#{category}=", true) if j.name == entry }
    else
      journals << Journal.new("name" => entry, "#{category}".to_sym => true)
    end
  end
end

journals.each(&:save)
