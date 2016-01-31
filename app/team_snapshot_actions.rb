get '/team_snapshot' do
  if params[:team_choice] && params[:team_choice] != "Select Team..."
    team = TeamStat.find_by(team: params[:team_choice])
    @team_rank = team.rank
    @top_player_name = team.top_player
    @top_player_photo = team.top_player_photo
    @top_goalie_name = team.top_goalie
    @top_goalie_photo = team.top_goalie_photo
    @next_game = team.next_game
    @last_game = team.last_game
    @team = params[:team_choice]
  end
  @teams = WebScrape.all_teams.sort
  erb :'team_view/index'
end