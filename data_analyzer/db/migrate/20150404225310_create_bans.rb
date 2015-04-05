class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.integer :match_id, null: false
      t.string :region, null: false
      t.integer :champion_id, null: false
      t.integer :turn, null: false
      t.boolean :team_that_banned_won, null: false
    end
    # Ensure there are no duplicates
    add_index :bans, [:match_id, :region, :turn], unique: true
  end
end
