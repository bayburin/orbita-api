Claim.destroy_all
User.destroy_all
Department.destroy_all
Group.destroy_all
Role.destroy_all
EventType.destroy_all
Doorkeeper::Application.destroy_all
Doorkeeper::AccessToken.destroy_all

Doorkeeper::Application.create(
  [
    { name: 'Техподдержка', redirect_uri: '', scopes: '' },
    { name: 'Учет ВТ', redirect_uri: '', scopes: '' },
    { name: 'Приложение оператора архива КД', redirect_uri: '', scopes: '' }
  ]
)

Role.create(
  [
    { name: 'admin', description: 'Администратор' },
    { name: 'employee', description: 'Сотрудник предприятия' }
  ]
)
Department.create(
  [
    { dept: 712 },
    { dept: 713 },
    { dept: 714 },
    { dept: 715 },
    { dept: 821 }
  ]
)
Group.create(
  [
    { department: Department.find_by(dept: 714), name: 7141, description: 'Сектор ИТ' },
    { department: Department.find_by(dept: 714), name: 7142, description: 'Ремонт ВТ' },
    { department: Department.find_by(dept: 713), name: 713, description: 'Отдел 713' },
    { department: Department.find_by(dept: 821), name: 821, description: 'Бюро 1431' },
    { name: 'employee', description: 'Пользователь' }
  ]
)
User.create(
  [
    {
      role: Role.find_by(name: :employee),
      group: Group.find_by(name: :employee),
      id_tn: 1_000_000,
      tn: 1_000_000,
      fio: 'Пользователь'
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7141),
      id_tn: 12_880,
      tn: 17_664,
      login: 'BayburinRF',
      fio: 'Байбурин Равиль Фаильевич',
      work_tel: '84-29',
      email: 'bayburin@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7142),
      id_tn: 2709,
      tn: 24_125,
      login: 'DryannyhAG',
      fio: 'Дрянных Алексей Геннадьевич',
      work_tel: '24-80',
      email: 'drag@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7141),
      id_tn: 20_092,
      tn: 15_173,
      login: 'SilchenkoDM',
      fio: 'Сильченко Дмитрий Михайлович',
      work_tel: '28-74',
      email: 'dmitry@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 25_988,
      tn: 20_705,
      login: 'ShestakovAP',
      fio: 'Шестаков Алексей Петрович',
      work_tel: '30-81',
      email: 'shestakovap@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 25_410,
      tn: 20_834,
      login: 'PermyakovaEK',
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
      login: 'MihalchenkovME',
      fio: 'Михальченков Максим Евгеньевич',
      work_tel: '67-40',
      email: 'mihalchenkovme@iss-reshetnev.ru',
      is_vacation: false
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 713),
      id_tn: 14_779,
      tn: 9968,
      login: 'AtamanovAY',
      fio: 'Атаманов Алексей Юрьевич',
      work_tel: '66-13',
      email: 'ataman@iss-reshetnev.ru',
      is_vacation: false,
      is_default_worker: true
    },
    {
      role: Role.find_by(name: :admin),
      group: Group.find_by(name: 7141),
      id_tn: 24_883,
      tn: 20_072,
      login: 'ProhorovND',
      fio: 'Прохоров Никита Дмитриевич',
      work_tel: '50-49',
      email: 'prohorovnd@iss-reshetnev.ru',
      is_vacation: false,
      is_default_worker: false
    }
  ]
)

SdRequest.create(
  [
    {
      service_id: 62,
      service_name: 'Печать',
      ticket_identity: 5,
      ticket_name: 'Заявка на печать',
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
      parameters: [
        Parameter.create(name: 'Номер наряда', value: '2323-ЛЗ от 05.03.2019'),
        Parameter.create(name: 'Количество копий', value: '3')
      ],
      finished_at_plan: Time.zone.now + 2.days,
      works: [
        Work.create(group: Group.first, users: [User.first]),
        Work.create(group: Group.last, users: [User.last])
      ]
    },
    {
      service_id: 18,
      service_name: 'Ремонт и обслуживание компьютера',
      ticket_identity: 6,
      ticket_name: 'Заявка на ремонт',
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
      parameters: [
        Parameter.create(name: 'Тип', value: 'Системный блок'),
        Parameter.create(name: 'Инв. №', value: '765122'),
        Parameter.create(name: 'Модель', value: 'system product name / 16 Гб / nvidia geforce gt 730 / intel(r) core(tm) i5-6400 cpu @ 2.70ghz / wd wd5000azlx-00k2t scsi disk device')
      ],
      finished_at_plan: Time.zone.now + 5.days
    }
  ]
)

EventType.create(
  [
    {
      name: :open,
      description: 'Событие создания заявки/кейса',
      template: 'Заявка создана',
      is_public: true,
      order: 10
    },
    {
      name: :workflow,
      description: 'Было выполнило действие для решения проблемы',
      template: 'Выполнено действие: {workflow}',
      is_public: true,
      order: 60
    },
    # {
    #   name: :status,
    #   description: 'Изменен статус',
    #   template: 'Новый статус: {status}',
    #   is_public: true
    # },
    {
      name: :add_workers,
      description: 'Добавлены новые исполнители',
      template: 'Добавлены исполнители: {workers}',
      is_public: true,
      order: 20
    },
    {
      name: :del_workers,
      description: 'Исключены исполнители',
      template: 'Исключены исполнители: {workers}',
      is_public: true,
      order: 30
    },
    {
      name: :escalation,
      description: 'Вынос проблемы на вышестоящее руководство',
      template: 'Эскалация',
      is_public: true,
      order: 70
    },
    {
      name: :postpone,
      description: 'Изменен срок исполнения',
      template: 'Срок исполнения перенесен на {datetime}',
      is_public: true,
      order: 50
    },
    {
      name: :close,
      description: 'Событие закрытия заявки/кейса',
      template: 'Заявка закрыта',
      is_public: true,
      order: 1000
    },
    # {
    #   name: :comment,
    #   description: 'Был добавлен комментарий',
    #   template: 'Добавлен комментарий: {comment}',
    #   order: 100
    # },
    {
      name: :add_files,
      description: 'Прикреплены новые файлы',
      template: 'Прикреплены файлы: {files}',
      is_public: true,
      order: 80
    },
    {
      name: :del_files,
      description: 'Удалены файлы',
      template: 'Удаленные файлы: {files}',
      order: 90
    },
    {
      name: :add_tags,
      description: 'Добавлены теги',
      template: 'Добавлены теги: {tags}',
      order: 110
    },
    {
      name: :priority,
      description: 'Изменен приоритет',
      template: 'Новый приоритет: {priority}',
      is_public: true,
      order: 40
    }
  ]
)
