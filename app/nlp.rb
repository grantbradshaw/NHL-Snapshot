module SportsNLP

  @markov = MarkyMarkov::TemporaryDictionary.new

  def self.train(string)
    SportsTwitter.search(string, 400).each do |tweet|
      @markov.parse_string(clean_tweet(tweet.text))
    end
  end

  def self.markov_speak(string)
    train(string)
    word = @markov.generate_n_sentences 1
    @markov.clear!
    word
  end

  def self.clean_tweet(string)
    string = remove_url(string)
    string = remove_hashtag(string)
    string = remove_reference(string)
    string = remove_retweet(string)
  end

  def self.remove_url(string)
    string.gsub(URI.regexp, '')
  end

  def self.remove_hashtag(string)
    string.gsub(/#\w*/, '')
  end

  def self.remove_reference(string)
    string.gsub(/@\w*/, '')
  end

  def self.remove_retweet(string)
    string.gsub(/ ?RT/, '')
  end
end