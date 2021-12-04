require "json"
require_relative "card"
require "terminal-table"

class List
  attr_reader :id, :name, :cards
  @@id_count = 0

  def initialize(id: nil, name:, cards: [])
    @id = id ? id : @@id_count.next
    @@id_count = id
    @name = name
    @cards = cards.map { |card_data| Card.new(card_data)}
  end

  def create
    @name = ""
    while @name.empty?
      puts "Name: "
      @name = gets.chomp
    end

  end

  def print_list
    print_table(title: "#{@name}",
                headings: ["ID", "Title", "Members", "Labels", "Due Date", "Checklist"])
  end

  def print_table(title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = list.map(&:details)
    puts table
  end

  def update(name:)
    @name = name unless name.empty?
  end

  def details
    [@id, @title]
  end

  def to_json(_generator)
    { id: @id, name: @name, cards: @cards }.to_json
  end

end