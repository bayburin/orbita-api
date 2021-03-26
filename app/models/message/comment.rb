# Класс, описывающий комментарии к заявке.
class Comment < Message
  belongs_to :claim
end
