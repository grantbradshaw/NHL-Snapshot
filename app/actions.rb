# Homepage (Root path)
require_relative 'sentence'

get '/' do
  @sentence = session[:current_phrase]
  @user = User.find(session[:user])
  erb :index
end

get '/login/:id' do # currently can login as developer at id 1, test at id 2, with associated collections
  session.clear
  session[:user] = params[:id]
  redirect '/'
end

post '/generate' do
  session[:current_phrase] = Sentence.sentence_creator
  redirect '/'
end

post '/save' do 
  @saved_phrase = SavedPhrase.new(
    collection_id: Collection.find_by(user_id: session[:user]).id,
    phrase: session[:current_phrase])
  @saved_phrase.save! # we should find a way to handle error from saving empty phrase
  session[:current_phrase] = nil # we should find a better way to keep users from saving input twice
  redirect '/'
end

post '/your_collection' do
  redirect "users/#{session[:user]}/collection"
end

get '/users/:id/collection' do
  erb :'your_collection/index'
end