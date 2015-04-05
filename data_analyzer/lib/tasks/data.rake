namespace :data do
  DATA_FILE_PATTERN = "../data/*.gz"

  def with_each_match
    Dir.glob(DATA_FILE_PATTERN).each_with_index do |filename, i|
      begin
        json = Zlib::GzipReader.open(filename) { |gz| JSON.parse(gz.read) }
        yield json, i
      rescue JSON::ParserError => e
        # In rare cases, JSON may be invalid
        puts "Invalid: #{filename}"
      end
    end
  end

  task insert_bans: :environment do
    with_each_match do |match|
      puts match["matchId"]
      match["teams"].each do |team|
        # If they have no bans, team["bans"] will be `nil`
        team["bans"].andand.each do |ban|
          Ban.find_or_create_by!({
            match_id: match["matchId"],
            region: match["region"],
            turn: ban["pickTurn"],
            champion_id: ban["championId"],
            team_that_banned_won: team["winner"],
          })
        end
      end
    end
  end

  task insert_picks: :environment do
    with_each_match do |match|
      puts match["matchId"]
      match["participants"].each do |participant|
        pick = Pick.find_or_initialize_by({
          match_id: match["matchId"],
          region: match["region"],
          champion_id: participant["championId"],
          team_id: participant["teamId"],
        })
        if pick.new_record?
          stats = participant["stats"]
          team = match["teams"].find { |team| team["teamId"] == participant["teamId"] }
          pick.update!({
            team_first_inhibitor: team["firstInhibitor"],
            team_first_tower: team["firstTower"],
            team_first_blood: team["firstBlood"],
            team_won: stats["winner"],
            match_duration_seconds: match["matchDuration"],
            highest_achieved_season_tier: participant["highestAchievedSeasonTier"],
            champion_level: stats["champLevel"],
            kills: stats["kills"],
            deaths: stats["deaths"],
            assists: stats["assists"],
            double_kills: stats["doubleKills"],
            triple_kills: stats["tripleKills"],
            quadra_kills: stats["quadraKills"],
            penta_kills: stats["pentaKills"],
            killing_sprees: stats["killingSprees"],
            total_damage_dealt: stats["totalDamageDealt"],
            total_damage_taken: stats["totalDamageTaken"],
            minions_killed: stats["minionsKilled"],
            wards_placed: stats["wardsPlaced"],
            first_blood_kill: stats["firstBloodKill"],
            gold_earned: stats["goldEarned"],
          })
        end
      end
    end
  end
end
