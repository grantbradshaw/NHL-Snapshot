get '/team_snapshot' do
  if params[:team_choice] && params[:team_choice] != "Select Team..."
    @team_rank = WebScrape.team_rank(params[:team_choice])
    @top_player = WebScrape.top_scoring_player(params[:team_choice])
    @top_goalie = WebScrape.top_goalie(params[:team_choice])
    @next_game = WebScrape.next_game(params[:team_choice])
    @last_game = WebScrape.last_game(params[:team_choice])
    @team = params[:team_choice]
  end
  @teams = WebScrape.all_teams.sort
  erb :'team_view/index'
end