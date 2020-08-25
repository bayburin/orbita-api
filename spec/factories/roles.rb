FactoryBot.define do
  factory :admin_role, class: Role do
    name { 'admin' }
    description { 'Администратор' }
  end

  factory :manager_role, class: Role do
    name { 'manager' }
    description { 'Менеджер' }
  end
end
