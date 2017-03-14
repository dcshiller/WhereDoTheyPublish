class TitleDistillator
  def self.get_words
    Rails.cache.fetch("distillates"){ distillate! }
  end

  def self.distillate!
    dictionary = {}
    Publication.articles.find_each.each do |pub|
      title_words = pub.proper_title.gsub(":","").gsub("'","").gsub('"',"").gsub(",","").split(" ")
      title_words.each do |word|
        next unless word.length > 2
        dictionary[word] &&= dictionary[word] + 1
        dictionary[word] ||= 0
      end
    end
    words = dictionary.select {|k,v| v > 50}
  end

  def self.distillate_and_write!
    File.open('data/title_words', 'w') { |file| file.write(distillate!.sort.join("\n")) }
  end
end