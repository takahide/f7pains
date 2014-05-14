require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql2'
require 'haml'
require 'nokogiri'
require 'open-uri'

ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')

ActiveRecord::Base.establish_connection(:local_dev) if development?
ActiveRecord::Base.establish_connection(:pains_dev) if production?

class Jockey < ActiveRecord::Base
end


for page in 1..4 do
  html = Nokogiri::HTML(open('http://db.netkeiba.com/?pid=jockey_leading&year=2014&page=' + page.to_s))

  html.css('td a').each do |a|
    href = a.attr("href")
    if href.index("/jockey/") == 0
      jockey_id = href.split("/")[2]
      name = a.text
      Jockey.where(jockey_id: jockey_id).first_or_create do |j|
        j.jockey_id = jockey_id
        j.name = name
      end
    end
  end
end
