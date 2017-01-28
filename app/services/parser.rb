class Parser
  TITLES = %w[ de van von le De Van Von Le ]
  def parse_line(line)
    apq = Journal.find_by(name: "American Philosophical Quarterly")
    Publication.new(journal: apq, title: get_title(line), authors: get_authors(line), publication_year: get_year(line))
  end

  def get_year(line)
    /\((.*?)\)/.match(line)[0][1..-2].to_i
  end

  def get_names(line)
    #Handle Junio
    line.gsub(";","&")
    /.*?\(/.match(line)[0][0..-2].split("&")
  end

  def get_last_name(name)
    parts = name.split(",")
    last_name = parts[0]
    parts[0]
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

  def get_title(line)
    /\).*?American/.match(line)[0][3..-11]&.proper_titlecase&.strip
  end

  def get_authors(line)
    names = get_names(line)
    names.map do |name|
      Author.find_by(first_name: get_first_name(name), middle_initial: get_middle_initial(name), last_name: get_last_name(name)) ||
        Author.new(first_name: get_first_name(name), middle_initial: get_middle_initial(name), last_name: get_last_name(name))
    end
  end
end