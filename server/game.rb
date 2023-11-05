
class Game
  attr_accessor :id, :clients, :started, :turn_index
  alias :started? :started

  def initialize(id, hostID)
    @id, @clients = id, [hostID]
    @turn_index, @started = 0, false
  end

  def to_s()
    "ID: " + @id.to_s + ", clients: " + @clients.to_s + ", turn: " + @turn_index.to_s
  end

  def serialize()
    {id: @id, clients: @clients, turn_index: @turn_index, started: @started}
  end

  def next_turn()
    @turn_index = (@turn_index + 1) % @clients.length
  end

  def is_my_turn(clientID)
    @clients[@turn_index] == clientID
  end

  def is_in_game(clientID)
    @clients.include?(clientID)
  end

  def add_player(clientID)
    @clients.append(clientID)
  end

  def remove_player(clientID)
    @clients.delete(clientID)
  end
end

class GameServer
  attr_accessor :nextClientID, :nextGameID, :games, :player_to_game

  def initialize()
    @nextClientID, @nextGameID = 0, 0
    @games = []
    @player_to_game = {}
  end

  def get_next_client_id()
    @nextClientID += 1
  end

  def to_json()
    (@games.map {|game| game.serialize}).to_json
  end

  def new_game(hostID)
    @games.append(Game.new(@nextGameID += 1, hostID))
    @player_to_game[hostID] = @nextGameID
  end
end
