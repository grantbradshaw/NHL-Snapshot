module Sentence

  file = File.read('app/words.json')
  @generator = JSON.parse(file)

  def self.sentence_creator
    
    sentence = ""
    
    @generator["structure"].sample.each do |word|
      case word
      when "noun"
        sentence << @generator["words"]["noun"].sample + " "
        next
      when "verb"
        sentence << @generator["words"]["verb"].sample + " "
        next
      when "adjective"
        sentence << @generator["words"]["adjective"].sample + " "
        next
      when "adverb"
        sentence << @generator["words"]["adverb"].sample + " "
        next
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

  def self.random_player
    @generator["athletes"][random_team].sample
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