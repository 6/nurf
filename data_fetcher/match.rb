require 'active_support/all'
require 'rest-client'
require 'json'
require 'rounding'
require 'zlib'

class Match
  REGIONS = %i(
    br
    eune
    euw
    kr
    lan
    las
    na
    oce
    ru
    tr
  )
  DATETIME_BUCKET_SIZE = 5.minutes

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

  def self.recent_datetime_buckets(n)
    # Floor to closest 5 minute offset
    start_at = (Time.now - DATETIME_BUCKET_SIZE).floor_to(DATETIME_BUCKET_SIZE)
    datetimes = []
    n.times do |i|
      datetimes << start_at - (i * DATETIME_BUCKET_SIZE)
    end
    # Convert to epoch seconds
    datetimes.map(&:to_i)
  end

  # Datetime bucket is epoch seconds representing the start date for the game
  # list. Must represent a time with an even 5 minute offset.
  def self.where(region:, datetime_bucket:)
    url = "#{api_base_url(region)}/v4.1/game/ids?beginDate=#{datetime_bucket}&api_key=#{api_key}"
    match_ids = JSON.parse(RestClient.get(url))
    match_ids.map { |match_id| new(id: match_id, region: region) }
  rescue RestClient::Exception => e
    puts "Error: #{e.response}"
    []
  end

  def data
    url = "#{Match.api_base_url(region)}/v2.2/match/#{id}?includeTimeline=true&api_key=#{Match.api_key}"
    @data ||= RestClient.get(url)
  end

  def save_to(path)
    Zlib::GzipWriter.open(path) { |gz| gz.write(data) }
  rescue RestClient::Exception => e
    puts "Error: #{e.response}"
  end
end
