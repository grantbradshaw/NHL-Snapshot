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

post '/saved_phrase' do 
  session[:current_phrase] = Sentence.sentence_creator
  redirect '/'
end

post '/saved_phrases' do 
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

get '/collection' do
  redirect "users/#{session[:user]}/collection"
end

get '/users/:id/collection' do
  @collection = Collection.find_by(user_id: params[:id])
  @phrases = SavedPhrase.where(collection_id: @collection.id)
  erb :'collection/index'
end

get '/collections' do
  @user = session[:user]
  erb :'collections/index'
end

delete '/saved_phrase/:id' do 
  SavedPhrase.delete(params[:id])
  redirect "users/#{session[:user]}/collection"
end

delete '/saved_phrases' do 
  Collection.find_by(user_id: current_user.id).saved_phrases.destroy_all
  redirect "users/#{session[:user]}/collection"
end

put '/users/:id/collection/edit_shared' do
  @collection = Collection.find_by(user_id: current_user.id)
  @collection.shared = !@collection.shared
  @collection.save!
  redirect "users/#{session[:user]}/collection"
end

get '/users/:id/collection/edit_title' do 
  @collection = Collection.find_by(user_id: current_user.id) 
  erb :'/collection/edit'
end

put '/users/:id/collection' do 
  @collection = Collection.find_by(user_id: current_user.id)
  if @collection.update_attributes(title: params[:title])
    redirect "/users/#{session[:user]}/collection"
  else
    erb :'/collection/edit'
  end
end
