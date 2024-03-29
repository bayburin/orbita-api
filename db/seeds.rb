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
    { name: 'Astraea', redirect_uri: '', scopes: '' },
    { name: 'Архив КД', redirect_uri: '', scopes: '' }
  ]
)

Role.create(
  [
    { name: 'admin', description: 'Администратор' },
    { name: 'worker', description: 'Исполнитель' },
    { name: 'employee', description: 'Работник предприятия' }
  ]
)
# Department.create(
#   [
#     { dept: 712 },
#     { dept: 713 },
#     { dept: 714 },
#     { dept: 715 },
#     { dept: 821 }
#   ]
# )

Group.create({ name: 'employee', description: 'Пользователь' })

User.create(
  {
    role: Role.find_by(name: :employee),
    group: Group.find_by(name: :employee),
    id_tn: 1_000_000,
    tn: 1_000_000,
    fio: 'Пользователь'
  }
)

user_tns = ['8567', '24119', '15173', '7857', '17664', '18734', '14749', '15092', '11817', '24036', '4018', '15871', '24125', '18068', '828', '2081', '18642', '19300', '20072', '24061', '24124', '9933', '24060', '6382', '9968', '4022', '3223', '3681', '9762', '3703', '13818', '8822', '3702', '6826', '8823', '15205', '11447', '3737', '24079', '24123', '24112', '6283', '18146', '16945', '13161', '1466', '4155', '3992', '3996', '6724', '20546', '23151', '18883', '20244', '3983', '20441', '24099', '24066', '148869', '7625', '24031', '24070', '11752', '14322', '24043', '23780', '20616', '20243', '3975', '24071', '20834', '20866', '20705', '19206', '15858', '15173', '21056', '16422', '24100', '8174', '3748', '8125', '10287', '15881', '9473', '19547', '16408', '4824', '4769', '1523', '21219', '24049', '18525', '6571', '21248', '1864', '21342', '21336', '19055', '20303', '21452', '20888', '24098', '20753', '24042', '24037', '492', '443', '4502', '6608', '4026', '24126', '24085', '21632', '3019', '21659', '10251', '4063', '4076', '6417', '21853', '3683', '24108', 8174, 12696, 12966, 15170, 8173, 8175, 8575, 8172, 8675, 4630, 13250, 15988, 11168, 13223, 10991, 15883, 16941, 21360, 15867, 16814, 10788, 2422, 18014, 8569, 8582, 8176, 8568, 8566, 16744, 13119, 20508, 8125, 15835, 17395, 8127, 15760, 19835, 919, 13904, 16822, 4036, 8119, 16364, 15606]
depts = Employees::Loader.new(:by_tn).load(user_tns)['data'].map(&:deep_symbolize_keys).group_by { |u| u[:departmentForAccounting] }

depts.keys.sort.each do |dept_number|
  dept = Department.create(dept: dept_number)
  groups = depts[dept_number].group_by { |u| u[:struct] }
  groups.keys.sort.each do |group_number|
    group = dept.groups.create(name: group_number)
    groups[group_number].each do |user|
      u = Employees::Loader.new(:load).load(user[:id]).deep_symbolize_keys
      group.users.create(
        role: Role.find_by(name: :worker),
        id_tn: u[:id],
        tn: user[:personnelNo],
        login: u[:employeeContact][:login],
        fio: user[:fullName],
        work_tel: u[:employeeContact][:phone].first,
        email: u[:employeeContact][:email].first,
        is_vacation: false
      )
    end
  end
end

User.find_by(tn: 9968).update(is_default_worker: true)

group_names = [
  {
    group: 7121,
    name: 'Группа автоматизации задач планирования и финансовый контроллинг'
  },
  {
    group: 7122,
    name: 'Группа проектирования и разработки программного обеспечения автоматизации бухгалтерского учёта и отдела организации труда и зарплаты'
  },
  {
    group: 7123,
    name: 'Группа автоматизации задач управления Обществом'
  },
  {
    group: 7124,
    name: 'Группа автоматизации закупочной деятельности Общества'
  },
  {
    group: 7131,
    name: 'Группа разработки и сопровождения АСУП'
  },
  {
    group: 7132,
    name: 'Сектор эксплуатации информационных систем'
  },
  {
    group: 7133,
    name: 'Группа автоматизации задач производственной логистики'
  },
  {
    group: 7141,
    name: 'Сектор информационных технологий'
  },
  {
    group: 7142,
    name: 'Сектор ремонта персональных компьютеров'
  },
  {
    group: 7143,
    name: 'Сектор развития и ремонта локальной сети Общества'
  },
  {
    group: 7144,
    name: 'Сектор внедрения мультимедийных технологий и разработки веб-ресурсов'
  },
  {
    group: 7145,
    name: 'Сектор защиты информации'
  },
  {
    group: 7146,
    name: 'Группа аппаратно-программных комплексов ЦУП КА'
  },
  {
    group: 7147,
    name: 'Сектор ремонта печатающих устройств'
  },
  {
    group: 71501,
    name: 'Группа внедрения и сопровождения систем автоматизированного проектирования и систем электронного документооборота конструкторской документации'
  },
  {
    group: 71502,
    name: 'Группа разработки программного обеспечения для автоматизации задач документооборота и делопроизводства'
  },
  {
    group: 71503,
    name: 'Группа автоматизированных систем технологической подготовки производства'
  },
  {
    group: 71504,
    name: 'Группа сопровождения и эксплуатации программного обеспечения'
  },
  {
    group: 8211,
    name: 'Бюро электронного документооборота'
  },
  {
    group: 8212,
    name: 'Копировально-множительное бюро'
  },
  {
    group: 82112,
    name: 'Группа проведения извещений об изменении в подлинниках КД'
  }
]

names = group_names.map { |group| group[:group] }
groups = Group.where(name: names)
groups.each { |group| group.update(description: group_names.find { |g| g[:group].to_s == group.name }[:name]) }

Group.find_by(name: 'УИВТ').update(description: 'Управление информатики и вычислительной техники')
Group.find_by(name: '712').update(description: 'Отдел автоматизации финансово-экономических задач')
Group.find_by(name: '713').update(description: 'Отдел автоматизации задач управления производством')
Group.find_by(name: '714').update(description: 'Отдел технических средств и ремонта вычислительной техники')
Group.find_by(name: '715').update(description: 'Отдел САПР и автоматизированных систем технологической подготовки производства')
Group.find_by(name: '821').update(description: 'Отдел научно-технической документации')
Group.find_by(name: '8211').update(description: 'Бюро электронного документоооборота')
Group.find_by(name: '8212').update(description: 'Копировально-множительное бюро')

# Group.create(
#   [
#     { department: Department.find_by(dept: 714), name: 7141, description: 'Сектор ИТ' },
#     { department: Department.find_by(dept: 714), name: 7142, description: 'Ремонт ВТ' },
#     { department: Department.find_by(dept: 713), name: 713, description: 'Отдел 713' },
#     { department: Department.find_by(dept: 821), name: 821, description: 'Бюро 1431' },
#     { name: 'employee', description: 'Пользователь' }
#   ]
# )
# User.create(
#   [
#     {
#       role: Role.find_by(name: :employee),
#       group: Group.find_by(name: :employee),
#       id_tn: 1_000_000,
#       tn: 1_000_000,
#       fio: 'Пользователь'
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 7141),
#       id_tn: 12_880,
#       tn: 17_664,
#       login: 'BayburinRF',
#       fio: 'Байбурин Равиль Фаильевич',
#       work_tel: '84-29',
#       email: 'bayburin@iss-reshetnev.ru',
#       is_vacation: false
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 7142),
#       id_tn: 2709,
#       tn: 24_125,
#       login: 'DryannyhAG',
#       fio: 'Дрянных Алексей Геннадьевич',
#       work_tel: '24-80',
#       email: 'drag@iss-reshetnev.ru',
#       is_vacation: false
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 7141),
#       id_tn: 20_092,
#       tn: 15_173,
#       login: 'SilchenkoDM',
#       fio: 'Сильченко Дмитрий Михайлович',
#       work_tel: '28-74',
#       email: 'dmitry@iss-reshetnev.ru',
#       is_vacation: false
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 713),
#       id_tn: 25_988,
#       tn: 20_705,
#       login: 'ShestakovAP',
#       fio: 'Шестаков Алексей Петрович',
#       work_tel: '30-81',
#       email: 'shestakovap@iss-reshetnev.ru',
#       is_vacation: false
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 713),
#       id_tn: 25_410,
#       tn: 20_834,
#       login: 'PermyakovaEK',
#       fio: 'Пермякова Евгения Константиновна',
#       work_tel: '67-10',
#       email: 'permyakovaek@iss-reshetnev.ru',
#       is_vacation: false
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 821),
#       id_tn: 6283,
#       tn: 6283,
#       login: 'MihalchenkovME',
#       fio: 'Михальченков Максим Евгеньевич',
#       work_tel: '67-40',
#       email: 'mihalchenkovme@iss-reshetnev.ru',
#       is_vacation: false
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 713),
#       id_tn: 14_779,
#       tn: 9968,
#       login: 'AtamanovAY',
#       fio: 'Атаманов Алексей Юрьевич',
#       work_tel: '66-13',
#       email: 'ataman@iss-reshetnev.ru',
#       is_vacation: false,
#       is_default_worker: true
#     },
#     {
#       role: Role.find_by(name: :admin),
#       group: Group.find_by(name: 7141),
#       id_tn: 24_883,
#       tn: 20_072,
#       login: 'ProhorovND',
#       fio: 'Прохоров Никита Дмитриевич',
#       work_tel: '50-49',
#       email: 'prohorovnd@iss-reshetnev.ru',
#       is_vacation: false,
#       is_default_worker: false
#     }
#   ]
# )

# SdRequest.create(
#   [
#     {
#       service_id: 62,
#       service_name: 'Печать',
#       ticket_identity: 5,
#       ticket_name: 'Заявка на печать',
#       description: '',
#       status: :opened,
#       priority: :default,
#       source_snapshot: SourceSnapshot.create(
#         id_tn: 25_988,
#         tn: 20_705,
#         fio: 'Шестаков Алексей Петрович',
#         dept: 713,
#         user_attrs: {
#           email: 'shestakovap@iss-reshetnev.ru',
#           'Телефон': '30-81',
#           'Мобильный': '8-988-455-23-45'
#         },
#         invent_num: '766123'
#       ),
#       parameters: [
#         Parameter.create(name: 'Номер наряда', value: '2323-ЛЗ от 05.03.2019'),
#         Parameter.create(name: 'Количество копий', value: '3')
#       ],
#       finished_at_plan: Time.zone.now + 2.days,
#       works: [
#         Work.create(group: Group.first, users: [User.first]),
#         Work.create(group: Group.last, users: [User.last])
#       ]
#     },
#     {
#       service_id: 18,
#       service_name: 'Ремонт и обслуживание компьютера',
#       ticket_identity: 6,
#       ticket_name: 'Заявка на ремонт',
#       description: '',
#       status: :opened,
#       priority: :default,
#       source_snapshot: SourceSnapshot.create(
#         id_tn: 12_880,
#         tn: 17_664,
#         fio: 'Байбурин Равиль Фаильевич',
#         dept: 714,
#         user_attrs: {
#           email: 'shestakovap@iss-reshetnev.ru',
#           'Телефон': '84-29',
#           'Мобильный': '8-111-222-33-22'
#         },
#         invent_num: '155784'
#       ),
#       parameters: [
#         Parameter.create(name: 'Тип', value: 'Системный блок'),
#         Parameter.create(name: 'Инв. №', value: '765122'),
#         Parameter.create(name: 'Модель', value: 'system product name / 16 Гб / nvidia geforce gt 730 / intel(r) core(tm) i5-6400 cpu @ 2.70ghz / wd wd5000azlx-00k2t scsi disk device')
#       ],
#       finished_at_plan: Time.zone.now + 5.days
#     }
#   ]
# )

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
      description: 'Было выполнено действие для решения проблемы',
      template: '{workflow}',
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
    },
    {
      name: :add_self,
      description: 'Исполнитель подключился к работе',
      template: 'Подключился к работе',
      is_public: true,
      order: 15
    }
  ]
)
