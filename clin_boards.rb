require "json"
require "terminal-table"
require_relative "store"

class ClinBoards
  attr_reader :store

  def initialize
    # Complete this
    @store = Store.new("store.json")
  end

  def start
    # Complete this
  end
end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
