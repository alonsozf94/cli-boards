require "json"
require_relative "checklist"

class Card
  attr_reader :id, :title, :members, :label, :due_date, :checklist
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

  def create_card(id)
    list_select = requester_create_card_option(id)
    resul = requester_create_card
    card_data = { id: nil, title: resul[0], members: resul[1], labels: resul[2], due_date: resul[3] }
    new_card = Card.new(card_data)
    card_created_send(id, list_select, new_card)
  end

  def update(list:, title:, members:, labels:, due_date:)
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

  def card_created_send(id_list, list_select, new_card)
    @store.each do |board|
      next unless board.id == id_list.to_i

      board.lists.each do |list|
        list.cards.push(new_card) if list.name == list_select
      end
    end
  end

  

  def to_json(_generator)
    { id: @id, title: @title, members: @members, labels: @labels, due_date: @due_date, checklist: @checklist}.to_json
  end
end