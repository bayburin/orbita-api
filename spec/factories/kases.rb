FactoryBot.define do
  factory :astraea_kase, class: Astraea::Kase do
    initialize_with { new(attributes) }

    case_id { 100 }
    user_tn { 17_664 }
    id_tn { 12_880 }
    host_id { '765344' }
    desc { 'test description' }
    service_id { nil }
    ticket_id { nil }
    item_id { 123 }
    barcode { 456 }
    phone { '12-34' }
    time { 1618642512 }
    severity { 'low' }
    status_id { 1 }
    users { [create(:manager).tn, create(:manager).tn] }
    messages do
      [
        {
          type: 'analysis',
          info: 'fake analysis'
        },
        {
          type: 'measure',
          info: 'fake measure'
        },
        {
          type: 'comment',
          info: 'fake comment'
        }
      ]
    end
  end
end
