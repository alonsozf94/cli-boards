require "json"
require_relative "card"

class List
  attr_reader :id, :name, :cards
  @@id_count = 0
  
  def initialize(name:, id: nil, cards: [])
    @id = id ? id : @@id_count.next
    @@id_count = id
    @name = name
    @cards = cards.map { |card_data| Card.new(card_data)}
  end

  def update(name:)
    @name = name unless name.empty?
  end

  def to_json(_generator)
    { id: @id, name: @name, cards: @cards}
  end

end