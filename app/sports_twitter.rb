module SportsTwitter

  include Twitter::Extractor

  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "8LmHZZjAyDukeAouq4FRAhGYl"
    config.consumer_secret     = "D62GHOeIdPFyzkaImTsTFosYddvtB7B15wlBzVb7vDYx2NUcwL"
    config.access_token        = "2255389962-N0FAMDVsO9guQdJcO2oVDmt8hbETbvmdCfbIrpM"
    config.access_token_secret = "9sTNH217Em3eieDwo4ucSKEwe2uB3x2oWXTEAdQc3cPjK"
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