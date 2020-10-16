class Runtime
  include ActiveModel::Serialization
  include Virtus.value_object

  DATE_FORMAT = '%d.%m.%Y'.freeze
  TIME_FORMAT = '%H:%M'.freeze

  values do
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :finished_at_plan, DateTime
    attribute :finished_at, DateTime
  end
end
