class AnalysisHelper
  def self.regions
    @regions ||= Pick.pluck("distinct region")
  end

  def self.season_tiers
    @season_tiers ||= Pick.pluck("distinct highest_achieved_season_tier")
  end

  def self.champion_ids
    @champion_ids ||= Pick.pluck("distinct champion_id")
  end

  def self.match_count_for_region(region)
    return @match_counts[region]  if @match_counts.andand[region]

    @match_counts = {}
    @match_counts["all"] = Pick.count("distinct match_id")
    regions.each do |region|
      @match_counts[region] = Pick.where(region: region).count("distinct match_id")
    end
    @match_counts[region]
  end

  def self.save_to_aggregate_data(name, data)
    File.write("../aggregate_data/#{name}.json", data.to_json)
  end
end
