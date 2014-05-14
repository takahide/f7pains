require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql2'
require 'haml'

ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')

ActiveRecord::Base.establish_connection(:local_dev) if development?
ActiveRecord::Base.establish_connection(:pains_dev) if production?

class Race < ActiveRecord::Base
end

races = Race.all()
races.each{|race|
  distance = race.distance
  course = distance.slice!(0)
  if course == "芝"
    race.course = 0
  elsif course == "ダ"
    race.course = 1
  elsif course == "障"
    race.course = 2
  end
  race.length = distance
  race.save
}
