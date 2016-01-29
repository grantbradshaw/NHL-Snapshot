module SportsNLP

  @markov = markov = MarkyMarkov::TemporaryDictionary.new

  def self.train(string)
    SportsTwitter.search(string, 400).each do |tweet|
      @markov.parse_string(remove_url(tweet.text))
    end
  end

  def self.markov_speak(string)
    train(string)
    puts @markov.generate_n_sentences 1
    @markov.clear!
  end

  def self.remove_url(string)
    string.gsub(URI.regexp, '')
  end
end