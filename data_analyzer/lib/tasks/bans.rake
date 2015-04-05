namespace :bans do
  # Ban rate by champion_id, for each region and all regions
  task analyze_ban_rates: :environment do
    rates = {}
    (AnalysisHelper.regions + ["all"]).each do |region|
      puts "Analyzing bans by region: #{region}"
      rates[region] = {}
      AnalysisHelper.champion_ids.each do |champion_id|
        scope = Ban.where(champion_id: champion_id)
        scope = scope.where(region: region)  if region != "all"
        ban_count = scope.count
        ban_rate_percent = (ban_count.to_f / AnalysisHelper.match_count_for_region(region)) * 100
        rates[region][champion_id] = ban_rate_percent
      end
    end
    AnalysisHelper.save_to_aggregate_data("ban_rates", rates)
  end

  task analyze_first_ban_rates: :environment do
    rates = {}
    (AnalysisHelper.regions + ["all"]).each do |region|
      puts "Analyzing first bans by region: #{region}"
      rates[region] = {}
      AnalysisHelper.champion_ids.each do |champion_id|
        scope = Ban.where(turn: 1, champion_id: champion_id)
        scope = scope.where(region: region)  if region != "all"
        ban_count = scope.count
        ban_rate_percent = (ban_count.to_f / AnalysisHelper.match_count_for_region(region)) * 100
        rates[region][champion_id] = ban_rate_percent
      end
    end
    AnalysisHelper.save_to_aggregate_data("first_ban_rates", rates)
  end

  task analyze_win_rates_by_ban: :environment do
    rates = {}
    (AnalysisHelper.regions + ["all"]).each do |region|
      puts "Analyzing win rates by bans by region: #{region}"
      rates[region] = {}
      AnalysisHelper.champion_ids.each do |champion_id|
        scope = Ban.where(champion_id: champion_id)
        scope = scope.where(region: region)  if region != "all"
        ban_count = scope.count
        ban_and_won_count = scope.where(team_that_banned_won: true).count
        win_rate_percent = (ban_and_won_count / ban_count.to_f) * 100
        rates[region][champion_id] = win_rate_percent
      end
    end
    AnalysisHelper.save_to_aggregate_data("win_rates_by_ban", rates)
  end
end
