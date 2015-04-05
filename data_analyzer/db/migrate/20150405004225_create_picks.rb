class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.integer :match_id, null: false
      t.string :region, null: false
      t.integer :champion_id, null: false
      t.integer :team_id, null: false
      t.boolean :team_first_inhibitor, null: false
      t.boolean :team_first_tower, null: false
      t.boolean :team_first_blood, null: false
      t.boolean :team_won, null: false
      t.integer :match_duration_seconds, null: false

      t.string :highest_achieved_season_tier, null: false
      t.integer :champion_level, null: false
      t.integer :kills, null: false
      t.integer :deaths, null: false
      t.integer :assists, null: false
      t.integer :double_kills, null: false
      t.integer :triple_kills, null: false
      t.integer :quadra_kills, null: false
      t.integer :penta_kills, null: false
      t.integer :killing_sprees, null: false
      t.integer :total_damage_dealt, null: false
      t.integer :total_damage_taken, null: false
      t.integer :minions_killed, null: false
      t.integer :gold_earned, null: false
      t.integer :wards_placed, null: false
      t.boolean :first_blood_kill, null: false
    end
    # Ensure no duplicates
    add_index :picks, [:match_id, :region, :champion_id, :team_id], unique: true
  end
end
