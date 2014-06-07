require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql2'

ActiveRecord::Base.configurations = YAML.load_file('../config/database.yml')

ActiveRecord::Base.establish_connection(:local_dev) if development?
ActiveRecord::Base.establish_connection(:pains_dev) if production?

class Player < ActiveRecord::Base
end
class Game < ActiveRecord::Base
end
class Score < ActiveRecord::Base
end
class Team < ActiveRecord::Base
end

scores = Score.all()

for s in scores
  if s.hit
    next
  end
  result = s.result
  if result.index "球"
    s.hit = 1
  elsif result.index "安"
    s.hit = 2
  elsif result.index "２"
    s.hit = 3
  elsif result.index "３"
    s.hit = 4
  elsif result.index "本"
    s.hit = 5
  else
    s.hit = 0
  end
  s.save
end
