require_relative 'sentence'
require_relative 'nlp'
require_relative 'sports_twitter'
require_relative 'auth_actions'
require_relative 'saved_phrase_actions'
require_relative 'collection_actions'
require_relative 'user_actions'
require_relative 'team_snapshot_actions'
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
  
  session[:current_phrase] ||= session[:twitter] ? SportsNLP.markov_speak(Sentence.random_player) : Sentence.sentence_creator
  

  if session[:field_blank]
    @field_blank = session[:field_blank]
    session[:field_blank] = nil
  end
  @phrase_count = Collection.find_by(user_id: current_user.id).saved_phrases.count if current_user
  @sentence = session[:current_phrase]

  if params['twitter']
    session[:twitter] = params['twitter'] == 'y' ? true : false
  end
  @use_twitter = session[:twitter]

  @top_three_svp = LeagueStat.where(search_term: 'top_three_svp').order(:rank)
  @top_three_pts = LeagueStat.where(search_term: 'top_three_pts').order(:rank)
  @top_three_teams = LeagueStat.where(search_term: 'top_three_teams').order(:rank)
  @bottom_three_teams = LeagueStat.where(search_term: 'bottom_three_teams').order(:rank)
  @top_three_links = Tweet.all.where(search_term: 'nhl')
  erb :index
end


