Role.destroy_all
Role.create([
  {
    name: 'admin',
    description: 'Администратор'
  }
])
