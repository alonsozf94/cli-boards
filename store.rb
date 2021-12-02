require "json"
require_relative "clin_boards"
class Store
    attr :board

    # Store related
    def inititalize(filename)
      @filename = filename
      @board = load_board
    end

    # List related

    # Card related

    # Checklist related

    private

    def save
      File.write(@filename, board.to_json)
    end

    def load_board
      data = JSON.parse(File.read("store.json"), {symbolize_names: true})
      data.map do |board_data|
        Board.new(board_data)
      end
    end
end