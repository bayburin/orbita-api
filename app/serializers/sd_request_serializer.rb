class SdRequestSerializer < ClaimSerializer
  attributes :integration_id, :application_id, :service_id, :ticket_identity, :service_name, :ticket_name, :rating
end
