class TitleDistillator
  def self.distillate!
    dictionary = {}
    Publication.articles.find_each.each do |pub|
      title_words = pub.proper_title.split(" ")
      title_words.each do |word|
        bare_word = word.chomp(":")
        dictionary[bare_word] ||= 0 if bare_word.length > 5
        dictionary[bare_word] &&= dictionary[bare_word] + 1 if bare_word.length > 5
      end
    end
    words = dictionary.select {|k,v| v > 200}.keys
    debugger
    3
  end
end