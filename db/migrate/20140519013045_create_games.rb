class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :team
      t.integer :opponent
      t.timestamps  #=> この一行でcreated_atとupdated_atのカラムが定義される
    end
  end
  def self.down
    drop_table :games
  end
end
