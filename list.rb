require "json"
require_relative "card"

class List
  attr_reader :id, :name, :description, :cards
  @@id_count = 0

  def initialize(id: nil, name:, cards: [])
    @id = id ? id : @@id_count.next
    @@id_count += 1
    @name = name
    @cards = cards.map { |card_data| Card.new(card_data)}
  end

  def update(name:, description:)
    @name = name unless name.empty?
    @description = description unless description.empty?
  end

  def details
    [@id, @title, @description]
  end

  def to_json(_generator)
    { id: @id, name: @name, cards: @cards }.to_json
  end

end