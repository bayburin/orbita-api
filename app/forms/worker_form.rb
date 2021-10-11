# Описывает форму исполнителей по конкретной работе.
class WorkerForm < Reform::Form
  property :id
  property :work_id
  property :user_id
end
