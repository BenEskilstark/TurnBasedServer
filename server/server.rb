
require 'sinatra'
require_relative 'game'

configure do
  set :port, 8000
end

# everything in this folder is accessible to public without a
# specific route below:
# set :public_folder, __dir__ + '/www'



server = GameServer.new


get '/id' do
  id = server.nextClientID += 1
  {id: id}.to_json
end

post '/new_game' do
  clientID = (JSON.parse request.body.read)["ID"]
  server.new_game(clientID)
  200
end

get '/list_games' do
  server.to_json
end

post '/join_game' do
  req_body = JSON.parse request.body.read
  server.games[req_body["gameID"]].add_player(req_body["ID"])
  200
end

post '/ready' do
  req_body = JSON.parse request.body.read
  server.games[req_body["gameID"]].ready(req_body["ID"])
end

post '/start_game' do
  req_body = JSON.parse request.body.read
  server.games[req_body["gameID"]].start
  200
end


post '/turn' do
  clientID = (JSON.parse request.body.read)["ID"]
  sleep(2)
  200
end

# regular files
get '/' do
  send_file File.join(__dir__, '../www/index.html')
end

get '/*' do |path|
  send_file File.join(__dir__, '../www/' + path)
end
