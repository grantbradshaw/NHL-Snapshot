get '/collection' do
  redirect "users/#{session[:user]}/collection"
end

get '/collections' do
  @user = session[:user]
  erb :'collections/index'
end