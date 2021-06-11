module Scope
  # Сортировка по id
  def by_id(direction)
    order(id: direction)
  end
end
