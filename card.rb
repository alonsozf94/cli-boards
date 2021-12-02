require "json"
require_relative "checklist"

class Card
  attr_reader id:, title:, members:, labels:, due_date:, checklist:
  @@id_count = 0

  def initialize(title:, id: nil, members:, labels:, due_date:, checklist: [])
    @id = id ? id : @@id_count
    @@id_count = id
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
    @checklist = checklist.map { |checklist_data| Checklist.new(checklist_data) }
  end

  def update(list:, title:, members:, labels:, due_date:)
    #TODO
    @title = title unless title.empty?
    @members = members unless members.empty?
    @labels = labels unless labels.empty?
    @due_date = due_date unless due_date.empty?
  end

  def to_json(_generator)
    { id: @id, title: @title, members: @members, labels: @labels, due_date: @due_date, checklist: @checklist}.to_json
  end
end