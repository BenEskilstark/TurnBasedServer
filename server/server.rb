
require 'sinatra'
require_relative 'game'

configure do
  set :port, 8000
end

# everything in this folder is accessible to public without a
# specific route below:
# set :public_folder, __dir__ + '/www'



server = GameServer.new

get '/' do
  send_file File.join(__dir__, '../www/index.html')
end

get '/id' do
  content_type :json
  id = server.nextClientID += 1
  {id: id}.to_json
end

post '/turn' do
  puts "TURN received"
  clientID = (JSON.parse request.body.read)["ID"]
  sleep(2)
  return 200
end

post '/new_game' do
  clientID = (JSON.parse request.body.read)["ID"]
  server.new_game(clientID)
end

get '/list_games' do
  server.to_json
end

post '/join_game' do

end

get '/*' do |path|
  send_file File.join(__dir__, '../www/' + path)
end
