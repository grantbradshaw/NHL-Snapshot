require_relative 'sentence'
require_relative 'nlp'
require_relative 'sports_twitter'
require_relative 'auth_actions'
require_relative 'saved_phrase_actions'
require_relative 'collection_actions'
require_relative 'user_actions'
require_relative 'scrape'

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

  @top_three_svp = WebScrape.top_three_svp
  @top_three_pts = WebScrape.top_three_pts
  @top_three_teams = WebScrape.top_three_teams
  @bottom_three_teams = WebScrape.bottom_three_teams
  @top_three_links = SportsTwitter.popular("nhl", 10, 3)
  erb :index
end

post '/team_view' do
  redirect '/team_view'
end

get '/team_view' do
  @teams = WebScrape.all_teams
  erb :'team_view/index'
end
