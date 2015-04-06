namespace :picks do
  task analyze_win_rates_by_champion: :environment do
    rates = {}
    (AnalysisHelper.regions + ["all"]).each do |region|
      puts "Analyzing win rates by region: #{region}"
      rates[region] = {}
      AnalysisHelper.champion_ids.each do |champion_id|
        scope = Pick.where(champion_id: champion_id)
        scope = scope.where(region: region)  if region != "all"
        match_count = scope.count
        win_count = scope.where(team_won: true).count
        win_rate_percent = (win_count.to_f / match_count) * 100
        rates[region][champion_id] = win_rate_percent
      end
    end
    AnalysisHelper.save_to_aggregate_data("win_rates_by_champion", rates)
  end

  task analyze_match_duration_seconds_by_champion: :environment do
    durations = {}
    (AnalysisHelper.regions + ["all"]).each do |region|
      puts "Analyzing match durations by region: #{region}"
      durations[region] = {}
      AnalysisHelper.champion_ids.each do |champion_id|
        scope = Pick.where(champion_id: champion_id)
        scope = scope.where(region: region)  if region != "all"
        average_match_duration_seconds = scope.average(:match_duration_seconds).to_f
        durations[region][champion_id] = average_match_duration_seconds
      end
    end
    AnalysisHelper.save_to_aggregate_data("match_duration_seconds_by_champion", durations)
  end
end
