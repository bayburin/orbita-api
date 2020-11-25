# Позволяет построить объект события Event.
class EventBuilder < BaseBuilder
  def initialize(params = {})
    @model = Event.new(params)

    super()
  end

  def claim_id=(claim_id)
    model.claim = Claim.find_by(id: claim_id)
  end

  def claim=(claim)
    model.claim = claim
  end

  def event_type=(event_type)
    model.event_type = EventType.find_by(name: event_type)
  end

  def id_tn=(id_tn)
    model.user = User.find_by(id_tn: id_tn)
  end

  def user=(user)
    model.user = user
  end

  def payload=(payload)
    model.payload = payload
  end
end
