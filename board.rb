require "json"
require_relative "list"

class Board
  attr_reader :id, :name, :description, :lists
  @@id_count = 0

  def initialize(name:, description:, id: nil, lists: [])
    @id = id ? id : @@id_count.next
    @@id_count = id
    @name = name
    @description = description
    @lists = lists.map { |list_data| List.new(list_data) } # Creates an array of List objects
  end

  def update(name:, description:)
    @name = name unless name.empty?
    @description = description unless description.empty?
  end

  def details
    list_array = @lists.map { |data| "#{data.name}(#{data.cards.length})" }
    [@id, @name, @description, list_array.join(", ")]
  end

  def to_json(_generator)
    { id: @id, name: @name, description: @description, lists: @lists }.to_json
  end
end