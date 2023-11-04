require 'sinatra'

configure do
  set :port, 8000
end

# everything in this folder is accessible to public without a
# specific route below:
# set :public_folder, __dir__ + '/www'


class Client
  attr_accessor :id, :my_turn
  alias :my_turn? :my_turn

  def initialize(id)
    @id, @my_turn = id, false
  end

  def to_s()
    "" + self.id.to_s + " my_turn? " + self.my_turn?.to_s
  end
end

clients = {}
nextID = 0

get '/' do
  send_file 'www/index.html'
end

get '/id' do
  content_type :json
  id = nextID += 1
  clients[id] = Client.new(id)
  clients[id].my_turn = true
  {id: id}.to_json
end

post '/turn' do
  puts "TURN received"
  client = clients[(JSON.parse request.body.read)["ID"]]
  client.my_turn = false
  puts client.to_s
  sleep(2)
  client.my_turn = true
  puts client.to_s
  return 200
end

get '/*' do |path|
  send_file 'www/' + path
end
