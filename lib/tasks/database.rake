namespace :db do
  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end

  desc "download query"
  task :query, [:author1] => :environment do |t, args|
    authors = [args[:author1]]
    authors.each do |author|
      # author = Author.new(first_name: "Derek", last_name: "Shiller")
      q = Query.new([author], 'philosophy', nil, nil, 1)
      start_count = Publication.count
      cr = CrossRefDispatcher.new(q)
      cr.dispatch
      pubs = cr.response
      PubSaver.save(pubs)
      puts "#{author} (+ #{Publication.count - start_count})"
      sleep 3
    end
  end

  task :read_file, [:filename,:journal,:divider] => :environment do |t, args|
    filename = args[:filename]
    divider = args[:divider] || args[:journal]
    journal = args[:journal] 
    lines = File.readlines("data/#{filename}")
    arr = []
    parser = Parser.new(journal, divider)
    lines.each do |line|
      pub = parser.parse_line(line)
      pub&.save
      print "."
    end
  end

  task get_next: :environment do
    query = ScheduledQuery.where(complete: false).first
    return unless query
    journal = (query.query if query.query_type == 'journal') || ""
    unless journal.blank?
      min = query.end
      year = query.start
      author = ([query.query.gsub(" ", "_")] if query.query_type == 'author') || ""
      while year > min do
        q = Query.new(author, 'philosophy', journal, year, 1)
        cr = CrossRefDispatcher.new(q)
        cr.dispatch
        pubs = cr.response
        PubSaver.save(pubs)
        year -= 1
        query.update_attributes(complete: true)
        puts year
        puts Publication.count
        sleep rand(15)
      end
    else
      time = Time.current
      while Time.current < time + 5.minutes
        min = query.end
        year = query.start
        journal = (query.query if query.query_type == 'journal') || ""
        author = ([query.query.gsub(" ", "_")] if query.query_type == 'author') || ""
        p = Publication.count
        q = Query.new(author, 'philosophy', journal, nil, 1)
        cr = CrossRefDispatcher.new(q)
        cr.dispatch
        pubs = cr.response
        PubSaver.save(pubs)
        author = Author.last
        author.destroy if author.publications.blank?
        additional_count = Publication.count - p
        puts additional_count
        query.update_attributes(complete: true, additional_count: additional_count)
        query = ScheduledQuery.where(complete: false).first
        sleep rand(5)
      end
    end
  end
  
  task :get_journal, [:name,:start,:end] => :environment do |t, args|
      continue = 4
      min = args[:end].to_i || 1900
      year = args[:start].to_i || 2016 
      while year > min do
        q = Query.new("", 'philosophy', args[:name] , year, 1)
        start_count = Publication.count
        cr = CrossRefDispatcher.new(q)
        cr.dispatch
        pubs = cr.response
        PubSaver.save(pubs)
        puts year
        puts Publication.count - start_count
        year -= 1
        continue -= 1 if Publication.count - start_count == 0
        sleep 2
      end
  end

  task condense: :environment do 
    Journal.find_each do |j|
      j.condensed_name = Journal.condensed_name(j.name)
      j.save
    end
  end
  
  task :query_all_authors, [:start] => :environment do |t, args|
    authors = "".split("\n")
    authors.each do |author|
      q = Query.new([author], 'philosophy', 1)
      start_count = Publication.count
      cr = CrossRefDispatcher.new(q)
      cr.dispatch
      pubs = cr.response
      PubSaver.save(pubs)
      puts "#{author} (+ #{Publication.count - start_count})"
      sleep 5
    end
  end
end
