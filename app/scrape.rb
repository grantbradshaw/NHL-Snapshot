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
    this_month = Time.now.month
    this_year = Time.now.year
    this_month_s = month_string(this_month)
    

    if this_month == 12
      next_month = 1
      next_month_s = month_string(next_month)
      next_year = this_year + 1
    else
      # next_month = this_month + 1
      this_month = Time.now.month - 1
      next_month = this_month  
      next_month_s = month_string(next_month)
      next_year = this_year
    end
    
    team_acro = @team_acronyms[team]

    this_month_file = open("http://nhlwc.cdnak.neulion.com/fs1/nhl/league/clubschedule/#{team_acro}/#{this_year.to_s}/#{this_month_s}/iphone/clubschedule.json")
    this_month_schedule = JSON.load(this_month_file)

    next_month_file = open("http://nhlwc.cdnak.neulion.com/fs1/nhl/league/clubschedule/#{team_acro}/#{next_year.to_s}/#{next_month_s}/iphone/clubschedule.json")
    next_month_schedule = JSON.load(next_month_file)

    next_game = this_month_schedule['games'].detect { |game| game['status'] != 'FINAL'}
    unless next_game
      next_game = next_month_schedule['games'].detect { |game| game['status'] != 'FINAL'}
    end

    next_game_opponent = @team_acronyms.detect { |k,v| v == next_game['abb']}
    next_game_day = next_game['startTime'].split(' ')[0]
    next_game_hour = next_game['startTime'].split(' ')[1]

    game_date = get_game_date(next_game_day)
    
    if game_date > Time.now
      "Against the <em>#{next_game_opponent[0]}</em> on #{next_game_day} at #{next_game_hour}"
    else
      "Could not find this game"
    end
  end

  def self.last_game(team)
    this_month = Time.now.month
    this_year = Time.now.year
    this_month_s = month_string(this_month)
    

    if this_month == 1
      last_month = 12
      last_month_s = month_string(last_month)
      last_year = this_year - 1
    else
      last_month = this_month - 1
      last_month_s = month_string(last_month)
      last_year = this_year
    end
    
    team_acro = @team_acronyms[team]

    this_month_file = open("http://nhlwc.cdnak.neulion.com/fs1/nhl/league/clubschedule/#{team_acro}/#{this_year.to_s}/#{this_month_s}/iphone/clubschedule.json")
    this_month_schedule = JSON.load(this_month_file)

    last_month_file = open("http://nhlwc.cdnak.neulion.com/fs1/nhl/league/clubschedule/#{team_acro}/#{last_year.to_s}/#{last_month_s}/iphone/clubschedule.json")
    last_month_schedule = JSON.load(last_month_file)

    last_game = this_month_schedule['games'].reverse.detect { |game| game['status'] == 'FINAL'}
    unless last_game
      last_game = last_month_schedule['games'].reverse.detect { |game| game['status'] == 'FINAL'}
    end

    last_game_opponent = @team_acronyms.detect { |k,v| v == last_game['abb']}
    last_game_outcome = last_game['score']
    last_game_win_loss = last_game_outcome.split(' ')[1]
    last_game_score = last_game_outcome.split(' ')[0]
    last_game_day = last_game['startTime'].split(' ')[0]

    all_games = []
    all_games << last_month_schedule['games']
    all_games << this_month_schedule['games']
    all_games.flatten!

    previous_games = all_games.select { |game| get_game_date(game['startTime'].split(' ')[0]) < Time.now}


    if previous_games[-1]['status'] == 'FINAL'
      if last_game_win_loss == 'W'
        "Defeated the <em>#{last_game_opponent[0]}</em> #{last_game_score} on #{last_game_day}"
      else
        "Lost to the <em>#{last_game_opponent[0]}</em> #{last_game_score} on #{last_game_day}"
      end
    else
      'Could not find this game'
    end
  end

  def self.month_string(month)
    month <= 9 ? "0" << month.to_s : month.to_s
  end

  def self.get_game_date(date_string)
    next_game_day_list = date_string.split('/')
    Date.new(next_game_day_list[0].to_i, next_game_day_list[1].to_i, next_game_day_list[2].to_i, 23)
  end

  def self.all_teams
    @team_acronyms.keys
  end
end



