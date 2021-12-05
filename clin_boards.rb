require "json"
require "terminal-table"
require_relative "store"

class ClinBoards

  def initialize
    # Complete this
    @store = Store.new("store.json")
  end

  def start
    action = ""
    until action == "exit"

      # Prints table
      print_table(list: @store.boards,
                  title: "CLIn Boards",
                  headings: ["ID", "Name", "Description", "List(#cards)"])

      # Shows menu and gets input
      print_menu("Board options: ",["create", "show [id]", "update [id]", "delete [id]"])
      action, id = get_action

      # Executes action
      case action
      when "create" then add_board
      when "show" then show_board(id)
      when "update" then update_board(id)
      when "delete" then delete_board(id)      
      when "exit"
        puts "Goodbye"
      else
        puts "Invalid action"
      end
    end
  end

  private

  # Showing Data
  # ---------------------

  def show_board(id)
    # Creates board object
    board = @store.find_board(id)
    action = ""

    until action == "back"
      # Prints table
      board.lists.each do |list|
        print_table(list: list.cards,
                  title: list.name,
                  headings: ["ID", "Title", "Members", "Labels", "Due Date", "Checklist"])
      end

      # Prints menu and gets options
      print_menu("List options: ", ["create-list", "update-list [name]", "delete-list [name]"])
      print_menu("Card options: ", ["create-card", "checklist [id]", "update-card [id]", "delete-card [id]"])
      puts "back"
      action, id = get_action

      # Executes action
      case action
      when "create-list" then add_list(board)
      when "update-list" then update_list(id, board)
      when "delete-list" then delete_list(id, board)
      when "create-card" then add_card(board)  
      when "checklist" then show_card_checklist(id.to_i, board)
      when "update-card" then update_card(id, board)
      when "delete-card" then delete_card(id, board)
      when "back" then next
      else puts "Invalid action"
      end
    end

  end

  def show_card_checklist(id, board)
    # Creates card object
    card = @store.find_card(id, board)
    action = ""

    until action == "back"
      # Prints card information
      puts "Card: #{card.title}"
      card.checklist.each_with_index do |item, index|
        puts "#{item.completed ? '[x]' : '[ ]'} #{index + 1}. #{item.title}"
      end

      # Prints menu and gets input
      puts "-------------------------------------"
      print_menu("Checklist options: ", ["add", "toggle [index]", "delete [index]"])
      puts "back"
      action, id = get_action

      # Executes action
      case action
      when "add" then add_check_item(card)
      when "toggle" then toggle(id, card)
      when "delete" then delete_check_item(id, card)
      when "back" then next
      end
    end
  end


  # Object Forms
  # ---------------------

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name, description: description }
  end

  def list_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name , description: description}
  end

  def card_form(board)
    list_array = board.lists.map { |list| list.name }
    print_menu("Select a list: \n", list_array)
    print "> "
    list_name = gets.chomp
    print "Title: "
    title = gets.chomp
    print "Members: "
    members = gets.chomp.split(", ").map(&:strip)
    print "Labels: "
    labels = gets.chomp.split(", ").map(&:strip)
    print "Due Date: "
    due_date = gets.chomp

    [{ title: title, members: members, labels: labels, due_date: due_date }, list_name]
  end

  # Creating objects
  # ---------------------

  def add_board
    new_data = board_form
    new_board = Board.new(new_data)
    @store.add_board(new_board)
  end

  def add_list(board)
    new_data = list_form
    new_list = List.new(new_data)
    @store.add_list(new_list, board)
  end

  def add_card(board)  
    new_data = card_form(board)
    new_card = Card.new(new_data[0])
    @store.add_card(new_card, new_data[1], board)
  end

  def add_check_item(card)
    print "Title: "
    title = gets.chomp
    new_check_item = Check_Item.new(title: title)
    @store.add_check_item(new_check_item, card)
  end


  # Updating objects
  # ---------------------

  def update_board(id)
    new_data = board_form
    @store.update_board(id, new_data)
  end

  def update_list(list_name, board)
    new_data = list_form
    @store.update_list(list_name, new_data, board.id)
  end

  def update_card(id, board)
    new_data = card_form(board)
    @store.update_card(id, new_data[0], board.id)
  end

  def toggle(index, card)
    @store.toggle(index, card)
  end

  # Deleting objects
  # ---------------------

  def delete_board(id)
    @store.delete_board(id)
  end

  def delete_list(list_name, board)
    @store.delete_list(list_name, board)
  end

  def delete_card(id, board)
    @store.delete_card(id, board)
  end

  def delete_check_item(index, card)
    @store.delete_check_item(index, card)
  end

  # Tables and input
  # ---------------------

  def print_table(list:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = list.map(&:details)
    puts table
  end

  def print_menu(prompt, options)
    puts prompt.to_s + options.join(" | ")
  end

  def get_action
    print "> "
    action, id = gets.chomp.split(" ", 2) # "show 1" -> ["show", "1"]
    unless (action == "update-list" || action == "delete-list")
      [action, id.to_i]
    else
      [action, id]
    end
  end

end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
