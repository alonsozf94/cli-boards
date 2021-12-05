require "json"
require_relative "check_item"

class Card
  attr_reader :title, :members, :label, :due_date, :checklist
  attr_accessor :id
  @@id_count = 0

  def initialize(title:, id: nil, members:, labels:, due_date:, checklist: [])
    @id = id ? id : @@id_count.next
    @@id_count += 1
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
    @checklist = checklist.map { |checklist_data| Check_Item.new(checklist_data) }
  end

  def update(title:, members:, labels:, due_date:)
    #TODO
    @title = title unless title.empty?
    @members = members unless members.empty?
    @labels = labels unless labels.empty?
    @due_date = due_date unless due_date.empty?
  end

  def details
    done = 0
    @checklist.each { |item| done += 1 if item.completed }
    [@id, @title, @members, @labels, @due_date, "#{done}/#{checklist.length}"]
  end

  def to_json(_generator)
    { id: @id, title: @title, members: @members, labels: @labels, due_date: @due_date, checklist: @checklist}.to_json
  end
end