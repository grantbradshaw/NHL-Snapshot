# Homepage (Root path)
require_relative 'sentence'

get '/' do
  @sentence = session[:current_phrase]
  @user = User.find(session[:user])
  erb :index
end

get '/login/:id' do # currently can only login as developer at id 1
  session[:user] = params[:id] 
  redirect '/'
end

post '/generate' do
  session[:current_phrase] = Sentence.sentence_creator
  redirect '/'
end

post '/save' do
  redirect '/'
end