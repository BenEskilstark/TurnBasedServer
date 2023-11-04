require 'sinatra'

configure do
  set :port, 8000
end

# everything in this folder is accessible to public without a
# specific route below:
# set :public_folder, __dir__ + '/www'


class Client
  attr_accessor :id, :my_turn?

  def initialize(id:)
    @id, @my_turn = id, false
  end
end

nextID = 0

get '/' do
  send_file 'www/index.html'
end

get '/id' do
  content_type :json
  {id: nextID += 1}.to_json
end

post '/turn' do
  puts "TURN received"
  client_id = (JSON.parse request.body.read)["ID"]
  puts client_id
  sleep(2)
  return 200
end

get '/*' do |path|
  send_file 'www/' + path
end
