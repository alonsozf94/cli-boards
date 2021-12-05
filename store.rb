require "json"
require_relative "board"

class Store
  attr_reader :boards

  def initialize(filename)
    @filename = filename
    @boards = load_board
  end

  # Add objects
  # ---------------------

  def add_board(new_board)
    @boards.push(new_board)
    save
  end
  
  def add_list(new_list, board)
      board.lists.push(new_list)
      save
  end

  def add_card(new_card, list_name, board)
      list = find_list(list_name, board)
      list.cards.push(new_card)
      save
  end
  
  def add_check_item(new_item, card)
    card.checklist.push(new_item)
    save
  end

  # Find Objects
  # ---------------------
  
  def find_board(id)
    @boards.find { |board| board.id == id }
  end

  def find_list(name, board)
      list_array = []
      board.lists.each do |list|
        list_array.push(list)
      end
      list_array.find { |list| list.name == name}
  end

  def find_card(id, board)
    card_array = []
    board.lists.each do |list|
      list.cards.each do |card|
        card_array.push(card)
      end
    end
    card_array.find { |card| card.id == id}
  end

  # Update Objects
  # ---------------------

  def update_board(id, new_data)
    board = find_board(id)
    board.update(new_data)
    save
  end

  def update_list(list_name, new_data, board_id)
    board = find_board(board_id)
    list = find_list(list_name, board)
    list.update(new_data)
    save
  end

  def update_card(id, new_data, board_id)
      list = find_board(board_id)
      card = find_card(id, list)
      card.update(new_data)
      save
  end

  def toggle(item_index,card)
    card.checklist.each_with_index do |item, index|
      (item.completed = item.completed ? false : true) if (index + 1) == item_index
    end
    save
  end
  
  # Delete objects
  # ---------------------

  def delete_board(id)
    board = find_board(id)
    @boards.delete(board)
    save
  end

  def delete_list(list_name, board)
    board.lists.delete_if { |list| list.name == list_name}
    save
  end
    
  def delete_card(id, board)
    board.lists.each { |list| list.cards.delete_if { |card| card.id == id} }
    save
  end

  def delete_check_item(index, card)
    card.checklist.delete_at(index.to_i - 1)
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

#objStore = Store.new("store.json")
#board = objStore.find_board(1)
#card = objStore.find_card(1, board)
#objStore.toggle(1, card)