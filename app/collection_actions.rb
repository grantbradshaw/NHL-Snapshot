get '/collection' do
  redirect "users/#{session[:user]}/collection"
end

get '/collections' do
  # @collections = Collection.where(shared: true).order(created_at: :desc)
  # order by newest created
  @collections = Collection.includes(:upvotes)
                .references(:upvotes)
                .where('collections.shared = ?', true)
                .group('collections.id', 'upvotes.id')
                .order('count(upvotes.collection_id) DESC')
  @user = session[:user]
  erb :'/collections/index'
end

get '/collection/:id/upvote' do 
  current_user.upvotes.create(
    collection_id: params[:id]
    )
  redirect '/collections'
end