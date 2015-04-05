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
end
