class Event
  include Virtus.model

  attribute :claim, Claim
  attribute :event_type, EventType
  attribute :user, User
  attribute :work, Work
  attribute :payload, Hash
end
