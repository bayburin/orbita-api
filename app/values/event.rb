class Event
  include Virtus.model

  attribute :claim_id, Integer
  attribute :event_type, EventType
  attribute :user_name, String
  attribute :id_tn, Integer
  attribute :payload, Hash
end
