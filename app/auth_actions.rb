get '/login/:id' do 
  session.clear
  session[:user] = params[:id]
  redirect '/'
end

get '/logout' do 
  session.clear
  redirect '/'
end
