require "json"

class Check_Item
  attr_reader :title, :completed

  def initialize(title:, completed: false)
    @title = title
    @completed = completed
  end

  def toggle
    @completed = true if @completed == false
    @completed = false if @completed
  end

  def to_json(_generator)
    { title: @title, completed: @completed }.to_json
  end
end