# Homepage (Root path)
require_relative 'sentence'

helpers do
  def is_users_collection?
    puts params[:id]
    session[:user] == params[:id]
  end

  def current_user
  end
end

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

get '/logout' do # need to allow access to webpage without being logged in
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
  @is_users_collection = is_users_collection?
  @collection = Collection.find_by(user_id: params[:id])
  @phrases = SavedPhrase.where(collection_id: @collection.id)
  erb :'your_collection/index'
end

post '/collections' do
  redirect '/collections'
end

get '/collections' do
  @user = session[:user]
  erb :'collections/index'
end

post '/delete' do 
  SavedPhrase.delete(params[:saved_phrase_id])
  redirect "users/#{session[:user]}/collection"
end

post '/delete_all' do 
  #SavedPhrase.destroy_all(collection_id: params[:collection_id]) if Collection.find(params[:collection_id]).user_id == session[:user_id] # only allows deletion if session user is user in url
  redirect "users/#{session[:user]}/collection"
end

post '/make_public' do # oof, public is a reserved word in ruby - we should not use that as a column name (or concatenate a ? to the end at least)
  #@collection = Collection.find_by(user_id: params[:id])
  #@collection.public = !@collection.public
  #@collection.save!
  redirect "users/#{session[:user]}/collection"
end
