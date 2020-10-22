class Event
  include Virtus.model

  attribute :claim_id, Integer
  attribute :type, String
  attribute :userName, String
  attribute :payload, Hash
end
