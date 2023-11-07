
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

post '/ready', provides: 'text/event-stream' do
  req_body = JSON.parse request.body.read
  game = server.games[req_body["gameID"]]
  clientID = req_body["ID"]
  game.set_ready(clientID)
  stream(:keep_open) do |out|
    game.connections[clientID] = [] << out
  end
end

post '/start_game' do
  req_body = JSON.parse request.body.read
  game = server.games[req_body["gameID"]]
  if game.ready.include? false
    return 403
  end

  game.start
  stream(:keep_open) do |out|
    game.connections[req_body["ID"]] = [] << out
  end

  # also tell ready-and-waiting clients their game has started
  game.connections.each do |clientID, conn|
    conn << {started: true}.to_json
    # conn.close
  end

  204 # response without body
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
