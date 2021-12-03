require "json"
require_relative "board"

class Store
    attr_reader :boards

    # Store related
    def initialize(filename)
      @filename = filename
      @boards = load_board
    end

    # List related

    # Card related

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