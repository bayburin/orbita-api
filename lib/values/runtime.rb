class Runtime < Dry::Struct
  include ActiveModel::Serialization

  DATE_FORMAT = '%d.%m.%Y'.freeze
  TIME_FORMAT = '%H:%M'.freeze

  attribute? :created_at, Types::Time.optional
  attribute? :updated_at, Types::Time.optional
  attribute :finished_at_plan, Types::Time.optional
  attribute? :finished_at, Types::Time.optional

  def finished_at_plan_str
    finished_at_plan.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")
  end
end
