class Event
  include Virtus.model

  attribute :claim_id, Integer
  attribute :type, String
  attribute :domainName, String
  attribute :payload, Hash
end
