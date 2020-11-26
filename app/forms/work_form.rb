# Описывает форму, которая создает работу по заявке.
class WorkForm < Reform::Form
  property :id
  property :claim_id
  property :group_id
  collection :users, form: UserForm, populate_if_empty: User, populator: :populate_users!

  validates :group_id, presence: true

  # Обработка ответственных
  def populate_users!(fragment:, **)
    item = users.find { |user| user.id == fragment[:id].to_i }

    if fragment[:_destroy].to_s == 'true'
      users.delete(item)
      return skip!
    end

    item || users.append(User.find(fragment[:id]))
  end
end
