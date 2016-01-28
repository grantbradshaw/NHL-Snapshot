# Homepage (Root path)
require_relative 'sentence'

get '/' do
  @sentence = session[:current_phrase]
  erb :index
end

post '/generate' do
  session[:current_phrase] = Sentence.sentence_creator
  redirect '/'
end