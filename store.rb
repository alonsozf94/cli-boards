require "json"
require_relative "board"

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
    def add_list(new_list, board)
      board.lists.push(new_list)
      save
    end
    
    def find_list(name, board)
      list_array = []
      board.lists.each do |list|
        list_array.push(list)
      end
      list_array.find { |list| list.name == name}
    end

    # Card related
    def add_card(new_card, list_name, board)
      list = find_list(list_name, board)
      list.cards.push(new_card)
      save
    end

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

    # Checklist related
    def add_check_item(new_item, card)
      card.checklist.push(new_item)
      save
    end

    private

    def save
      File.write(@filename, @boards.to_json)
    end

    def load_board
      data = JSON.parse(File.read(@filename), { symbolize_names: true })
      data.map do |board_data|
        Board.new(board_data)
      end
    end
end