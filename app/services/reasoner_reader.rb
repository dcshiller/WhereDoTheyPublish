class ReasonerReader
  TITLES = %w[ de van von le De Van Von Le ]
  attr_reader :journal_name, :divider

  def self.read
    lines = File.readlines('data/reasoner')
    pubs = []
    lines.each do |line|
      puts line
      if line.starts_with? "Volume"
        @volume = line.split(",")[0].scan(/\d/).join('')
        @number = line.split(/[\,,\-]/)[1]&.scan(/\d/)&.join('')
        @year = line.split(" - ")[1]&.scan(/\d/)&.join('')
      elsif line.starts_with? "Number"
        @number = line.split(/[\,,\-]/)[0].scan(/\d/).join('')
        @year = line.split(" - ")[1].scan(/\d/).join('')
      elsif !line.blank?
        title = line.split(" - ")[0]
        authors = line.split(" - ")[1].split(/[\&,\,]/)
        reasoner = Journal.find_by(name: "Reasoner")
        authors.map! do |author|
          Author.find_or_create_by_name(author)
        end
        pubs << Publication.create(title: title, journal: reasoner, authors: authors, publication_year: @year, volume: @volume, number: @number)
      end
    end
  end

  def parse_line(line)
    journal = Journal.find_by(name: journal_name)
    Publication.new(journal: journal, title: get_title(line, divider), authors: get_authors(line), publication_year: get_year(line), volume: get_volume(line), number: get_number(line), pages: get_pages(line))
  end

  def get_year(line)
    /\((.*?)\)/.match(line)[0][1..-2].to_i
  end

  def get_volume(line)
    line.split(divider)[1].split("(")[0].to_i
  end

  def get_number(line)
    line.split(divider)[1].split("(")&.[](1)&.split(")")&.[](0)&.strip
  end

  def get_pages(line)
    line.split(divider)[1].split(":")&.[](1)&.chomp(".\n")&.gsub(" ","")
  end

  def get_names(line)
    #Handle Junio
    line.gsub(";","&")
    /.*?\(/.match(line)[0][0..-2].split("&")
  end

  def get_last_name(name)
    parts = name.split(",")
    last_name = parts[0]
    parts[0].strip
  end

  def get_middle_initial(name)
    parts = name.split(" ")
    parts.shift
    parts.shift if TITLES.include? parts[0]
    parts.shift
    parts[0..-1]&.join(" ")&.strip
  end

  def get_first_name(name)
    parts = name.split(" ")
    last_name = parts[1]
    last_name = parts[2] if TITLES.include? parts[0]
    last_name.strip
  end

  def get_title(line, divider)
    /\).*?#{divider}/.match(line)[0][3..-1*(divider.length+1)]&.proper_titlecase&.strip.chomp(".")
  end

  def get_authors(line)
    names = get_names(line)
    names.map do |name|
      Author.find_by(first_name: get_first_name(name), middle_initial: get_middle_initial(name), last_name: get_last_name(name)) ||
        Author.new(first_name: get_first_name(name), middle_initial: get_middle_initial(name), last_name: get_last_name(name))
    end
  end
end