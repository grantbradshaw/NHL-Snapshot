module Sentence

  file = File.read('app/words.json')
  @generator = JSON.parse(file)

  def self.sentence_creator
    
    sentence = ""
    
    @generator["structure"].sample.each do |word|
      case word
      when "noun"
        to_add =  @generator["words"]["noun"].sample + " "
      when "verb"
        to_add =  @generator["words"]["verb"].sample + " "
      when "adjective"
        to_add = @generator["words"]["adjective"].sample + " "
      when "adverb"
        to_add = @generator["words"]["adverb"].sample + " "
      when "player"
        to_add = @generator["athletes"][random_team].sample + " "
      when "team"
        to_add = random_team + " "
      when "cliche"
        to_add = @generator["words"]["cliche"].sample + " "
      else
        sentence << word + " "
        next
      end

      if sentence.include? to_add
        return sentence_creator
      else
        sentence << to_add
      end
    end

    canadian_speak(sentence.strip())
  end

  private
    def self.random_team
      @generator["athletes"].keys.sample
    end

    def self.canadian_speak(sentence)
      sentence << ", eh?" if rand(10) == 5
      sentence
    end
end