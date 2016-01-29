require_relative 'sentence'
require_relative 'auth_actions'
require_relative 'saved_phrase_actions'
require_relative 'collection_actions'
require_relative 'user_actions'

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
