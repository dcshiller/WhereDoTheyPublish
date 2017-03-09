class Parser
  TITLES = %w[ de van von le De Van Von Le ]
  attr_reader :journal_name, :divider

  def initialize(journal_name, divider)
    @divider = divider
    @journal_name = journal_name
  end

  def parse_line(line)
    return unless line.include? divider
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
    #Handle Junior
    line = line.gsub(";","&")
    /.*?\(/.match(line)[0][0..-2].split("&")
  end

  def get_last_name(name)
    if name.strip[-1] == "," && (name.count(".") == 2 || name.count(".") == 3)
      last_name = name.split(".")[-1]
      last_name + "." if last_name
    else
      parts = name.split(",")
      last_name = parts[0].remove " Jr"
      parts[0].strip
    end
  end

  def get_middle_initial(name)
    if name.strip[-1] == "," && (name.count(".") == 2 || name.count(".") == 3)
      n = name.split(".")
      n&.shift
      n&.pop
      middle_initials = n&.join(". ") 
      middle_initials + "." if middle_initials
    else
      parts = name.split(" ")
      parts.shift
      parts.shift if TITLES.include? parts[0]
      parts.shift
      parts[0..-1]&.join(" ")&.strip
    end
  end

  def get_first_name(name)
    if name.strip[-1] == "," && (name.count(".") == 2 || name.count(".") == 3)
      first_name = name.split(".")[0]
      first_name + "." if first_name
    else
      parts = name.split(" ")
      first_name = parts[1]&.strip
    end
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