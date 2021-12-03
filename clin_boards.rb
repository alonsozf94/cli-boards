require "json"
require "terminal-table"
require_relative "store"

class ClinBoards

  def initialize
    # Complete this
    @store = Store.new("store.json")
  end

  def start
    # Complete this
    action = ""

    until action == "exit"
      print_table(list: @store.boards,
                  title: "CLIn Boards",
                  headings: ["ID", "Name", "Description", "List(#cards)"])
      action, id = menu(["create", "show ID", "update ID", "delete ID"])
      case action
      when "create" then puts "Its creating"
      when "show" then puts "Its showing"
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

  def print_table(list:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = list.map(&:details)
    puts table
  end

  def menu(options)
    puts options.join(" | ")
    print "> "
    action, id = gets.chomp.split # "show 1" -> ["show", "1"]
    [action, id.to_i]
  end

  def show_board(id)
  end

end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
