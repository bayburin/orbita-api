module SdRequests
  # Описывает форму, которая создает объект SourceSnapshot
  class SourceSnapshotForm < Reform::Form
    property :id
    property :claim_id
    property :id_tn
    property :tn
    property :fio
    property :dept
    property :user_attrs
    property :dns
    property :domain_user
    property :source_ip
    property :mac
    property :invent_num
    property :svt_item_id
    property :barcode
    property :os

    validation do
      config.messages.backend = :i18n

      params do
        required(:id_tn).filled(:int?)
        required(:tn).filled(:int?)
        required(:fio).filled
      end
    end
  end
end
