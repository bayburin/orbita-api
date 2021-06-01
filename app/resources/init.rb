class Init
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_reader :users, :groups, :event_types

  def initialize(attributes)
    @users = attributes[:users]
    @groups = attributes[:groups]
    @event_types = attributes[:event_types]
  end
end
