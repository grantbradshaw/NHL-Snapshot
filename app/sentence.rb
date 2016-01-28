require 'json'

file = File.read('words.json')
@generator = JSON.parse(file)


def sentence_creator
  
  sentence = ""
  
  @generator["structure"].sample.each do |word|
    case word
    when "noun"
      sentence << @generator["words"]["noun"].sample + " "
    when "verb"
      sentence << @generator["words"]["verb"].sample + " "
    when "adjective"
      sentence << @generator["words"]["adjective"].sample + " "
    when "adverb"
      sentence << @generator["words"]["adverb"].sample + " "
    when "player"
      sentence << @generator["athletes"][random_team].sample + " "
    when "team"
      sentence << random_team + " "
    when "cliche"
      sentence << @generator["words"]["cliche"].sample + " "
    else
      sentence << word + " "
    end
  end

  canadian_speak(sentence.strip())
end

def random_team
  @generator["athletes"].keys.sample
end

def canadian_speak(sentence)
  sentence << ", eh?" if rand(10) == 5
  sentence
end

puts sentence_creator