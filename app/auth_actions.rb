get '/login/:id' do 
  session.clear
  session[:user] = params[:id]
  session[:twitter] = false
  redirect '/'
end

get '/logout' do 
  session.clear
  redirect '/'
end
