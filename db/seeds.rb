Claim.destroy_all
User.destroy_all
Group.destroy_all
Role.destroy_all
EventType.destroy_all

Role.create(name: 'admin', description: 'Администратор')
Group.create(
  [
    { name: 7141, description: 'Сектор ИТ' },
    { name: 7142, description: 'Ремонт ВТ' },
    { name: 713, description: 'Отдел 713' },
    { name: 821, description: 'Бюро 1431' }
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
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7141),
      id_tn: 20092,
      tn: 15173,
      fio: 'Сильченко Дмитрий Михайлович',
      work_tel: '28-74',
      email: 'dmitry',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 25988,
      tn: 20705,
      fio: 'Шестаков Алексей Петрович',
      work_tel: '30-81',
      email: 'shestakovap',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 25410,
      tn: 20834,
      fio: 'Пермякова Евгения Константиновна',
      work_tel: '67-10',
      email: 'permyakovaek',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 821),
      id_tn: 6283,
      tn: 6283,
      fio: 'Михальченков Максим Евгеньевич',
      work_tel: '67-40',
      email: 'mihalchenkovme',
      is_vacation: false
    }
  ]
)

SdRequest.create(
  [
    {
      service_id: 62,
      service_name: 'Печать',
      app_template_id: 5,
      app_template_name: 'Заявка на печать',
      description: '',
      status: :opened,
      priority: :default,
      source_snapshot: SourceSnapshot.create(
        id_tn: 25_988,
        tn: 20_705,
        fio: 'Шестаков Алексей Петрович',
        dept: 713,
        user_attrs: {
          email: 'shestakovap@iss-reshetnev.ru',
          'Телефон': '30-81',
          'Мобильный': '8-988-455-23-45'
        },
        invent_num: '766123'
      ),
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
      description: '',
      status: :opened,
      priority: :default,
      source_snapshot: SourceSnapshot.create(
        id_tn: 12_880,
        tn: 17_664,
        fio: 'Байбурин Равиль Фаильевич',
        dept: 714,
        user_attrs: {
          email: 'shestakovap@iss-reshetnev.ru',
          'Телефон': '84-29',
          'Мобильный': '8-111-222-33-22'
        },
        invent_num: '155784'
      ),
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
      name: :created,
      description: 'Исполнитель создал заявку',
      template: 'Заявка создана'
    },
    {
      name: :workflow,
      description: 'Исполнитель выполнил действие',
      template: 'Выполнено действие: {workflow}'
    },
    {
      name: :comment,
      description: 'Исполнитель добавил комментарий',
      template: 'Добавлен комментарий: {comment}'
    },
    # {
    #   name: 'add_workers',
    #   description: 'Исполнитель подключил других исполнителей',
    #   template: 'Добавлены исполнители: {workers}'
    # },
    # {
    #   name: 'add_self',
    #   description: 'Исполниитель подключился к работе',
    #   template: 'Подключился к работе'
    # },
    # {
    #   name: 'remove_workers',
    #   description: 'Исполнитель исключил других исполнителей',
    #   template: 'Исключены исполнители: {workers}'
    # },
    # {
    #   name: 'remove_self',
    #   description: 'Исполниитель отключился от работы',
    #   template: 'Отключился от работы'
    # },
    {
      name: :postpone,
      description: 'Исполнитель перенесен срок исполнения',
      template: 'Срок исполнения перенесен с {old_datetime} на {new_datetime}'
    },
    {
      name: :close,
      description: 'Исполнитель закрыл заявку',
      template: 'Заявка закрыта'
    }
  ]
)
