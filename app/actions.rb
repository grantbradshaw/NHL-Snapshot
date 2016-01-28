# Homepage (Root path)
require_relative 'sentence'

helpers do
  def is_users_collection?
    puts params[:id]
    session[:user] == params[:id]
  end

  def current_user
    @current_user = session[:user] ? User.find(session[:user]) : nil
  end
end

get '/' do
  if session[:field_blank]
    @field_blank = session[:field_blank]
    session[:field_blank] = nil
  end
  @phrase_count = Collection.find_by(user_id: current_user.id).saved_phrases.count if current_user
  @sentence = session[:current_phrase]
  erb :index
end

get '/login/:id' do 
  session.clear
  session[:user] = params[:id]
  redirect '/'
end

get '/logout' do 
  session.clear
  redirect '/'
end

post '/generate' do
  session[:current_phrase] = Sentence.sentence_creator
  redirect '/'
end

post '/save' do 
  @saved_phrase = SavedPhrase.new(
    collection_id: Collection.find_by(user_id: current_user.id).id,
    phrase: session[:current_phrase])
  begin
    @saved_phrase.save!
    session[:current_phrase] = nil
  rescue ActiveRecord::RecordInvalid
    session[:field_blank] = true
  end
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

delete '/delete' do 
  SavedPhrase.delete(params[:saved_phrase_id])
  redirect "users/#{session[:user]}/collection"
end

delete '/delete_all' do 
  Collection.find_by(user_id: current_user.id).saved_phrases.destroy_all
  redirect "users/#{session[:user]}/collection"
end

post '/make_public' do # oof, public is a reserved word in ruby - we should not use that as a column name (or concatenate a ? to the end at least)
  #@collection = Collection.find_by(user_id: params[:id])
  #@collection.public = !@collection.public
  #@collection.save!
  redirect "users/#{session[:user]}/collection"
end
