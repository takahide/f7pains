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

class History < ActiveRecord::Base
end

races = Race.all()

races.each{|race|
  course = race.course
  length = race.length
  id = race.id

  histories = History.where(race: id)
  histories.each{|history|
    history.course = course
    history.length = length
    history.save
  }
}
