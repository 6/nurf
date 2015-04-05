# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150405004225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bans", force: :cascade do |t|
    t.integer "match_id",             null: false
    t.string  "region",               null: false
    t.integer "champion_id",          null: false
    t.integer "turn",                 null: false
    t.boolean "team_that_banned_won", null: false
  end

  add_index "bans", ["match_id", "region", "turn"], name: "index_bans_on_match_id_and_region_and_turn", unique: true, using: :btree

  create_table "picks", force: :cascade do |t|
    t.integer "match_id",                     null: false
    t.string  "region",                       null: false
    t.integer "champion_id",                  null: false
    t.integer "team_id",                      null: false
    t.boolean "team_first_inhibitor",         null: false
    t.boolean "team_first_tower",             null: false
    t.boolean "team_first_blood",             null: false
    t.boolean "team_won",                     null: false
    t.integer "match_duration_seconds",       null: false
    t.string  "highest_achieved_season_tier", null: false
    t.integer "champion_level",               null: false
    t.integer "kills",                        null: false
    t.integer "deaths",                       null: false
    t.integer "assists",                      null: false
    t.integer "double_kills",                 null: false
    t.integer "triple_kills",                 null: false
    t.integer "quadra_kills",                 null: false
    t.integer "penta_kills",                  null: false
    t.integer "killing_sprees",               null: false
    t.integer "total_damage_dealt",           null: false
    t.integer "total_damage_taken",           null: false
    t.integer "minions_killed",               null: false
    t.integer "gold_earned",                  null: false
    t.integer "wards_placed",                 null: false
    t.boolean "first_blood_kill",             null: false
  end

  add_index "picks", ["match_id", "region", "champion_id", "team_id"], name: "index_picks_on_match_id_and_region_and_champion_id_and_team_id", unique: true, using: :btree

end
