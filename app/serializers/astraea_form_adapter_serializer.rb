class AstraeaFormAdapterSerializer < ActiveModel::Serializer
  attributes :user_id, :case_id, :phone, :host_id, :barcode, :desc, :analysis, :rem_date, :rem_hour, :rem_min
  attributes :severity, :users
end
