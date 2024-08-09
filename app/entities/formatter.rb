# frozen_string_literal: true

class Formatter
  def self.list(entity, query)
    {
      items: query.map { item(entity, _1) },
      count: query.count
    }
  end

  def self.item(entity, item)
    entity.new(item).format
  end
end
