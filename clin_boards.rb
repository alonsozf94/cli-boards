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
      when "update" then puts "Its updating"
      when "delete" then puts "Its deleting"       
      when "exit"
        puts "Goodbye"
      else
        puts "Invalid action"
      end
    end
  end

  private

  # Showing Data

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
      when "update-list" then puts "Updates list"
      when "delete-list" then puts "Deletes list"
      when "create-card" then add_card(board)  
      when "checklist" then show_card_checklist(id.to_i, board)
      when "update-card" then puts "Updates card"
      when "delete-card" then puts "Deletes card"
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
        puts "#{index + 1}. #{item.title}"
      end

      # Prints menu and gets input
      puts "-------------------------------------"
      print_menu("Checklist options: ", ["add", "toggle [index]", "delete [index]"])
      puts "back"
      action, id = get_action

      # Executes action
      case action
      when "add" then add_check_item(card)
      when "toggle" then puts "Toggles checklist"
      when "delete" then puts "Delete checklist"
      when "back" then next
      end
    end
    #card.each_with_index { |check, index| puts "#{check.completed ? '[x]' : '[ ]'} #{index + 1}. #{check.title}" }
  end

  # Creating objects

  def add_board
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp

    new_board = Board.new(name: name, description: description)
    @store.add_board(new_board)
  end

  def add_list(board)
    print "Name: "
    name = gets.chomp

    new_list = List.new(name: name)
    @store.add_list(new_list, board)
  end

  def add_card(board)
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
    due_date = gets.chomp.split(", ")

    new_card = Card.new(title: title, members: members, labels: labels, due_date: due_date)
    @store.add_card(new_card, list_name, board)
  end

  def add_check_item(card)
    print "Title: "
    title = gets.chomp
    new_check_item = Check_Item.new(title: title)
    @store.add_check_item(new_check_item, card)
  end

  # Tables and input

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
    action, id = gets.chomp.split # "show 1" -> ["show", "1"]
    [action, id.to_i]
  end

end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
