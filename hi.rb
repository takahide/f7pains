require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql2'
require 'haml'
require 'slim'
require 'coffee_script'
require 'json'

configure :development do
  require 'sinatra/reloader'
  register Sinatra::Reloader
end

configure :production do
  set :port, 1111
end

set :port, 1111

ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')

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
class Order < ActiveRecord::Base
end
class Point < ActiveRecord::Base
end

class P
  attr_accessor :id, :name, :back_name, :number, :average, :homerun, :scores
  def initialize(player)
    @id = player.id
    @name = player.name
    @back_name = player.back_name
    @number = player.number

    scores = Score.where(player: player.id)
    hit = 0
    chance = 0
    homerun = 0
    latest_game = 0
    for s in scores
      if s.game > latest_game
        latest_game = s.game
      end
      if s.hit != 1
        chance = chance + 1
      end
      if s.hit >= 2
        hit = hit + 1
      end
      if s.hit == 5
        homerun = homerun + 1
      end
    end
    if chance == 0
      average = 0
    else
      average = (hit * 1000.0 / chance).round
    end
    @average = "." + format("%03d", average)
    @homerun = homerun
    @scores = scores

    sum = 0
    latest_scores = Score.where(game: latest_game, player: player.id)
    for l in latest_scores
      sum = sum + l.hit * 2
    end
    second_latest_scores = Score.where(game: latest_game - 1, player: player.id)
    for l in second_latest_scores
      sum = sum + l.hit
    end
    at_bat = latest_scores.length * 2 + second_latest_scores.length
    if at_bat == 0
      @condition = -1
    else
      @condition = sum * 1000 / at_bat
    end

  end

  def ten
    return (@number - (@number % 10)) / 10
  end
  def one
    return @number % 10
  end
  def condition
    if @condition >= 1200
      return 5
    elsif @condition >= 900
      return 4
    elsif @condition >= 600
      return 3
    elsif @condition >= 300
      return 2
    elsif @condition >= 0
      return 1
    else
      return 0
    end
    return @homerun
  end
end

class G
  attr_accessor :id, :opponent
  def initialize(id, opponent)
    @id = id; @opponent = opponent
  end
end

class O
  attr_accessor :id, :order, :position, :player, :scores
  def initialize(id, order, position, player, scores)
    @id = id; @order = order; @position = position; @player = player; @scores = scores
  end
end

class PointSlim
  attr_accessor :name, :points, :sum
  def initialize(name, points)
    @name = name; @points = points
    @sum = 0
    for p in points
      if p != "x" || p != "-"
        @sum += p.to_i
      end
    end
  end
end

get '/' do
  ActiveRecord::Base.connection_pool.with_connection do
    begin
      @team = Team.find(1)
      players = Player.where team: 1
      @players = Array.new
      for p in players
        @players.push P.new(p)
      end

      games = Game.where team: @team.id
      games = games.sort { |a, b|
        b.date <=> a.date
      }
      @games = Array.new
      for g in games
        t = Team.find g.opponent
        @games.push G.new(g.id, t.name)
      end
      slim :index
    end
  end
end

get '/details.html' do
  ActiveRecord::Base.connection_pool.with_connection do
    begin
      game_id = params['game']

      game = Game.find game_id
      team = Team.find game.opponent
      @game = G.new(game.id, team.name)

      orders = Order.where game: game_id
      @orders = Array.new
      @scores = Array.new
      @players = Array.new

      for o in orders
        p = Player.find o.player
        scores = Score.where game: game_id, player: p.id
        @orders.push O.new(o.id, o.order, o.position, p.first_name, scores)
        if p.team == game.team
          @players.push P.new(p)
        end
      end

      points = Point.where game: game_id
      for p in points
        point_array = p.points.split ","
        if p.top == 0
          @top = PointSlim.new(p.name, point_array)
        else
          @bottom = PointSlim.new(p.name, point_array)
        end
      end
      slim :details
    end
  end
end

get '/register.html' do
  ActiveRecord::Base.connection_pool.with_connection do
    begin
      game_id = params['game']
      @team = Team.find(1)
      @players = Player.where(team: 1)

      @game = Game.find(game_id)
      @opponent = Team.find(@game.opponent)
      slim :register
    end
  end
end

post '/register' do
  ActiveRecord::Base.connection_pool.with_connection do
    begin
      scores = Array.new
      for i in 0..9
        json = JSON.parse(params["score#{i}"])
        if json["result"] == ""
          next
        end
        Score.where(game: json["game"], player: json["player"], bat: i).first_or_create do |s|
          s.result = json["result"]
        end
      end
    end
  end
end

get %r{^/(.*)\.html$} do
  @id = params['id']
  @title = params['title']
  content_type :html, :charset => 'utf-8'
  slim :"#{ params[:captures].first }"
end

get '/css/style.css' do
  scss :'scss/style'
end

get '/js/app.js' do
  coffee :'coffee/app'
end

