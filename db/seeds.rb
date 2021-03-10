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
      email: 'bayburin@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7142),
      id_tn: 2709,
      tn: 24125,
      fio: 'Дрянных Алексей Геннадьевич',
      work_tel: '24-80',
      email: 'drag@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7141),
      id_tn: 20092,
      tn: 15173,
      fio: 'Сильченко Дмитрий Михайлович',
      work_tel: '28-74',
      email: 'dmitry@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 25988,
      tn: 20705,
      fio: 'Шестаков Алексей Петрович',
      work_tel: '30-81',
      email: 'shestakovap@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 25410,
      tn: 20834,
      fio: 'Пермякова Евгения Константиновна',
      work_tel: '67-10',
      email: 'permyakovaek@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 821),
      id_tn: 6283,
      tn: 6283,
      fio: 'Михальченков Максим Евгеньевич',
      work_tel: '67-40',
      email: 'mihalchenkovme@iss-reshetnev.ru',
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
      description: 'Событие создания заявки/кейса',
      template: 'Заявка создана',
      is_public: true
    },
    {
      name: :workflow,
      description: 'Было выполнило действие для решения проблемы',
      template: 'Выполнено действие: {workflow}',
      is_public: true
    },
    {
      name: :status,
      description: 'Изменен статус',
      template: 'Новый статус: {status}',
      is_public: true
    },
    {
      name: :add_workers,
      description: 'Добавлены новые исполнители',
      template: 'Добавлены исполнители: {workers}',
      is_public: true
    },
    {
      name: :del_workers,
      description: 'Исключены исполнители',
      template: 'Исключены исполнители: {workers}',
      is_public: true
    },
    {
      name: :escalation,
      description: 'Вынос проблемы на вышестоящее руководство',
      template: 'Эскалация',
      is_public: true
    },
    {
      name: :postpone,
      description: 'Изменен срок исполнения',
      template: 'Срок исполнения перенесен с {old_datetime} на {new_datetime}',
      is_public: true
    },
    {
      name: :close,
      description: 'Событие закрытия заявки/кейса',
      template: 'Заявка закрыта',
      is_public: true
    },
    {
      name: :comment,
      description: 'Был добавлен комментарий',
      template: 'Добавлен комментарий: {comment}'
    },
    {
      name: :add_files,
      description: 'Прикреплены новые файлы',
      template: 'Прикреплены файлы: {files}'
    },
    {
      name: :add_tags,
      description: 'Добавлены теги',
      template: 'Добавлены теги: {tags}'
    },
    {
      name: :priority,
      description: 'Изменен приоритет',
      template: 'Новый приоритет: {priority}'
    }
  ]
)
