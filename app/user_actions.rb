get '/users/:id/collection' do
   @collection = Collection.find_by(user_id: params[:id])
   @phrases = SavedPhrase.where(collection_id: @collection.id)
   erb :'collection/index'
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