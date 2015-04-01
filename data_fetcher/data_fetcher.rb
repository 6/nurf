require 'active_support/all'
require 'rest-client'
require 'json'

class Match
  attr_accessor :id, :region

  def initialize(id:, region:)
    @id = id
    @region = region
  end

  def self.api_key
    ENV["RIOT_API_KEY"]
  end

  def self.api_base_url(region)
    "https://#{region}.api.pvp.net/api/lol/#{region}"
  end

  # Datetime bucket is epoch seconds representing the start date for the game
  # list. Must represent a time with an even 5 minute offset.
  def self.where(region:, datetime_bucket:)
    url = "#{api_base_url(region)}/v4.1/game/ids?beginDate=#{datetime_bucket}&api_key=#{api_key}"
    match_ids = JSON.parse(RestClient.get(url))
    match_ids.map { |match_id| new(id: match_id, region: region) }
  end

  def data
    url = "#{Match.api_base_url(region)}/v2.2/match/#{id}?includeTimeline=true&api_key=#{Match.api_key}"
    @data ||= RestClient.get(url)
  end

  def save_to_directory(data_directory)
    path = "#{data_directory}/#{id}.json"
    File.write(path, data)  unless File.exist?(path)
  end
end
