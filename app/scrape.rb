module WebScrape
  points_leaders_file = open('http://nhlwc.cdnak.neulion.com/fs1/nhl/league/leagueleaders/iphone/points/leagueleaders.json')
  @points_leaders = JSON.load(points_leaders_file)

  svp_leaders_file = open('http://nhlwc.cdnak.neulion.com/fs1/nhl/league/leagueleaders/iphone/savepercentage/leagueleaders.json')
  @svp_leaders = JSON.load(svp_leaders_file)

  standings = open('http://app.cgy.nhl.yinzcam.com/V2/Stats/Standings')
  @standings = Nokogiri::XML(standings.read)


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
end