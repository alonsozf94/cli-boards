require "json"
require_relative "list"

class Board
  attr_reader :id, :name, :description, :lists
  @@id_count = 0
  
  def initialize(name:, description:, id: nil, lists: [])
    @id = id ? id : @@id_count.next
    @@id_count = id
    @name = name
    @lists = lists.map { |list_data| List.new(list_data)}
  end

  def update(name:, description:)
    @name = name unless name.empty?
    @description = description unless description.empty?
  end

  def details
    #TODO
  end

  def to_json(_generator)
    { id: @id, name: @name, description: @description, lists: @lists }
  end
end