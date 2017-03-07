class TitleDistillator
  def self.get_words
    Rails.cache.fetch("distillates"){ distillate! }
  end

  def self.distillate!
    dictionary = {}
    Publication.articles.find_each.each do |pub|
      title_words = pub.proper_title.gsub(":","").gsub("'","").gsub('"',"").split(" ")
      title_words.each do |word|
        next unless word.length > 3
        dictionary[word] &&= dictionary[word] + 1
        dictionary[word] ||= 0
      end
    end
    words = dictionary.select {|k,v| v > 200}.keys
  end
end