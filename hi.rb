require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql2'
require 'haml'
require 'slim'

configure :development do
  require 'sinatra/reloader'
  register Sinatra::Reloader
end

configure :production do
  set :port, 696
end

set :port, 696

ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')

ActiveRecord::Base.establish_connection(:local_dev) if development?
ActiveRecord::Base.establish_connection(:pains_dev) if production?

class Question < ActiveRecord::Base
end

class Category < ActiveRecord::Base
end

class History < ActiveRecord::Base
end

class Race < ActiveRecord::Base
end

class Jockey < ActiveRecord::Base
end

get '/' do
  slim :index
end

get '/questions' do
  ActiveRecord::Base.connection_pool.with_connection do
    begin
      content_type :json, :charset => 'utf-8'
      category_name = params['c']
      category = Category.where(name: category_name)
      questions = Question.where(category: category[0].id)
      questions.to_json
    end
  end
end

get '/any' do
  content_type :json, :charset => 'utf-8'
  query = params['q']
  jockey = Jockey.where(name: query)
end

get '/jockey' do
  ActiveRecord::Base.connection_pool.with_connection do
    begin
      content_type :json, :charset => 'utf-8'
      query = params['q']
      turf_lower = params['tl'].to_i
      turf_upper = params['tu'].to_i
      dirt_lower = params['dl'].to_i
      dirt_upper = params['du'].to_i
      jockey = Jockey.where(name: query)

      histories = History.where("((length >= ? and length <= ? and course = 0) or (length >= ? and length <= ? and course = 1)) and jockey_id = ?", turf_lower, turf_upper, dirt_lower, dirt_upper, jockey[0].jockey_id)
      result_histories = Array.new
      histories.each do |h|
        result_histories << h.name.strip + ":" + h.popularity.to_s + ":" + h.rank
      end
      result_histories.to_json
    end
  end
end


get '/player.html' do
  content_type :html, :charset => 'utf-8'
  player = Player.find(1)
  @name = player.name
  @first_name = player.first_name
  @number = player.number
  haml :player
end

get %r{^/(.*)\.html$} do
  content_type :html, :charset => 'utf-8'
  slim :"#{ params[:captures].first }"
end

get '/css/style.css' do
  scss :'scss/style'
end

get '/js/app.js' do
  coffee :'coffee/app'
end

