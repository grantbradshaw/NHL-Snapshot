module SportsTwitter

  include Twitter::Extractor

  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_KEY_SECRET']
    config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end

  def self.search(term, quantity)
    @client.search(term, result_type: "recent").take(quantity).collect
  end

  def self.find_url(term, quantity)
    urls = []
    search(term, quantity).each do |hit|
      Twitter::Extractor.extract_entities_with_indices(hit.text).each do |index|
        urls << index[:url] if index[:url]
      end
    end
    urls
  end

  def self.popular(term, quantity, results)
    find_url(term, quantity).frequency.sort_by(&:last).reverse[0..(results -1)]
  end
end