class RuntimeSerializer < ActiveModel::Serializer
  attributes :created_at, :updated_at, :finished_at_plan, :finished_at
end
