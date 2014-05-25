class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.integer :number
      t.timestamps  #=> この一行でcreated_atとupdated_atのカラムが定義される
    end
  end
  def self.down
    drop_table :players
  end
end
