class CreateTests < ActiveRecord::Migration
  def change
     create_table :tests, :options =>'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
       t.string :name
       t.integer :number
       t.timestamps
     end
  end
end
