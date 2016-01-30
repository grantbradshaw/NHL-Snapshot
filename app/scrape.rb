module WebScrape
  points_leaders_file = open('http://nhlwc.cdnak.neulion.com/fs1/nhl/league/leagueleaders/iphone/points/leagueleaders.json')
  @points_leaders = JSON.load(points_leaders_file)

  svp_leaders_file = open('http://nhlwc.cdnak.neulion.com/fs1/nhl/league/leagueleaders/iphone/savepercentage/leagueleaders.json')
  @svp_leaders = JSON.load(svp_leaders_file)

  standings = open('http://app.cgy.nhl.yinzcam.com/V2/Stats/Standings')
  @standings = Nokogiri::XML(standings.read)

  teams = File.read('app/teams.json')
  @team_acronyms = JSON.parse(teams)


  def self.top_three_svp
    top_goalies = []
    @svp_leaders["skaterData"][0..2].each do |goalie|
      goalie_hash = {name: '',
                     svp: ''}
      goalie_details = goalie['data'].split(", ")
      goalie_hash[:name] = goalie_details[3]
      goalie_hash[:svp] = goalie_details[6]
      top_goalies << goalie_hash
    end
    top_goalies
  end

  def self.top_three_pts
    top_points = []
    @points_leaders["skaterData"][0..2].each do |player|
      player_hash = {name: '',
                     points: ''}
      player_details = player['data'].split(", ")
      player_hash[:name] = player_details[3]
      player_hash[:svp] = player_details[7]
      top_points << player_hash
    end
    top_points
  end

  def self.league
    league_overview = []
    conferences = @standings.css('Conference')
    conferences.each do |conference|
      conference.css('StatsSection').each do |division|
        division.css('Standing').each do |team|
          team_details = {name: '',
                          rank: ''}

          team_details[:name] = team.attr('Team')
          team_details[:rank] = team.attr('LeagueRank').to_i

          league_overview << team_details
        end
      end
    end
    league_overview
  end

  def self.top_three_teams
    teams = league.select {|team| team[:rank] <= 3}
    teams.sort_by { |team| team[:rank] }
  end

  def self.bottom_three_teams
    teams = league.select {|team| team[:rank] >= 28}
    teams = teams.sort_by { |team| team[:rank] }
    teams.reverse
  end

  def self.team_rank(team)
    res = league.detect { |find| find[:name] == team}
    res[:rank]
  end

  def self.retrieve_team(team)
    team_acro = @team_acronyms[team]
    team_file = open("http://nhlwc.cdnak.neulion.com/fs1/nhl/league/playerstatsline/20152016/2/#{team_acro}/iphone/playerstatsline.json")
    JSON.load(team_file)
  end

  def self.get_photo(player_id)
    "http://3.cdn.nhle.com/photos/mugs/thumb/#{player_id}.jpg"
  end

  def self.top_scoring_player(team)
    team_players = retrieve_team(team)
    player_name = team_players['skaterData'][0]['data'].split(', ')[2]
    player_id = team_players['skaterData'][0]['id']
    [player_name, get_photo(player_id)]
  end

  def self.top_goalie(team)
    team_players = retrieve_team(team)
    ordered = team_players['goalieData'].sort_by { |goalie| goalie['data'].split(', ')[10]}
    player_name = ordered[-1]['data'].split(', ')[2]
    player_id = ordered[-1]['id']
    [player_name, get_photo(player_id)]
  end

  def self.next_game(team)
    month_i = Time.now.month
    month = month_i <= 9 ? "0" << month_i.to_s : month_i.to_s
  end

  def self.all_teams
    @team_acronyms.keys
  end
end




