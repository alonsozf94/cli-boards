require "json"
require_relative "board"
require_relative "card"

class Store
    attr_reader :boards

    def initialize(filename)
      @filename = filename
      @boards = load_board
    end

    # Board related
    def find_board(id)
      @boards.find { |board| board.id == id }
    end

    # List related

    # Card related
    def find_card(id, board)
      card_array = []
      board.lists.each do |list|
        cards = list.cards.each do |card|
          card_array.push(card)
        end
      end
      card_array.find { |card| card.id == id}
    end

    def delete_card(id)
      card = find_card(id)
      @cards.delete(card)
      save
    end

    def update_card(id, data)
      card = find_card(id)
      card.update(data)
      save
    end

    # Checklist related


    private

    def save
      File.write(@filename, board.to_json)
    end

    def load_board
      data = JSON.parse(File.read(@filename), { symbolize_names: true })
      data.map do |board_data|
        Board.new(board_data)
      end
    end
end

#obj = Store.new("store.json")
#board = obj.find_board(1)
#p obj.find_card(8, board)