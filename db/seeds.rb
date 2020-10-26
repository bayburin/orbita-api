Claim.destroy_all
User.destroy_all
Group.destroy_all
Role.destroy_all
EventType.destroy_all

Role.create(name: 'admin', description: 'Администратор')
Group.create(
  [
    { name: 7141, description: 'Сектор ИТ' },
    { name: 7142, description: 'Ремонт ВТ' }
  ]
)
User.create(
  [
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7141),
      id_tn: 12880,
      tn: 17664,
      fio: 'Байбурин Равиль Фаильевич',
      work_tel: '84-29',
      email: 'bayburin',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7142),
      id_tn: 2709,
      tn: 24125,
      fio: 'Дрянных Алексей Геннадьевич',
      work_tel: '24-80',
      email: 'drag',
      is_vacation: false
    }
  ]
)

Claim.create(
  [
    {
      service_id: 62,
      service_name: 'Печать',
      app_template_id: 5,
      app_template_name: 'Заявка на печать',
      status: :opened,
      priority: :default,
      id_tn: 25_988,
      tn: 20_705,
      fio: 'Шестаков Алексей Петрович',
      dept: 713,
      user_details: {
        email: 'shestakovap@iss-reshetnev.ru',
        phone: '30-81',
        mobile: '8-988-455-23-45'
      },
      attrs: {
        'Номер наряда': '2323-ЛЗ от 05.03.2019',
        'Количество копий': '3'
      },
      finished_at_plan: Time.zone.now + 2.days,
      works: [
        Work.create(group: Group.first, users: [User.first]),
        Work.create(group: Group.last, users: [User.last])
      ]
    },
    {
      service_id: 18,
      service_name: 'Ремонт и обслуживание компьютера',
      app_template_id: 6,
      app_template_name: 'Заявка на ремонт',
      status: :opened,
      priority: :default,
      id_tn: 12_880,
      tn: 17_664,
      fio: 'Байбурин Равиль Фаильевич',
      dept: 714,
      user_details: {
        email: 'bayburin@iss-reshetnev.ru',
        phone: '84-29',
        mobile: '8-111-222-33-22'
      },
      attrs: {
        'Тип': 'Системный блок',
        'Инв. №': '765122',
        'Модель': 'system product name / 16 Гб / nvidia geforce gt 730 / intel(r) core(tm) i5-6400 cpu @ 2.70ghz / wd wd5000azlx-00k2t scsi disk device'
      },
      finished_at_plan: Time.zone.now + 5.days
    }
  ]
)

EventType.create(
  [
    {
      name: 'workflow',
      description: 'Выполнено действие',
      template: 'Выполнено действие: {workflow}'
    },
    {
      name: 'comment',
      description: 'Добавлен комментарий',
      template: 'Добавлен комментарий: {comment}'
    },
    {
      name: 'add_worker',
      description: 'Добавлены исполнители',
      template: 'Добавлены исполнители: {workers}'
    },
    {
      name: 'postpone',
      description: 'Перенесен срок исполнения',
      template: 'Срок исполнения перенесен на {datetime}'
    },
    {
      name: 'close',
      description: 'Заявка закрыта',
      template: 'Заявка закрыта'
    }
  ]
)
