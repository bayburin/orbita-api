class Api::V1::ClaimsController < Api::V1::BaseController
  def index
    claims = Claim.includes(works: [:group, { workers: :user, histories: :event_type }]).group_by(&:type).map do |type, claims_arr|
      case type
      when 'SdRequest'
        ActiveModelSerializers::SerializableResource.new(
          claims_arr, each_serializer: SdRequestSerializer, include: ['works.histories.event_type', 'works.group', 'works.workers.user']
        )
      when 'Case'
        ActiveModelSerializers::SerializableResource.new(
          claims_arr, each_serializer: CaseSerializer, include: ['works.histories.event_type', 'works.group', 'works.workers.user']
        )
      end
    end

    render json: claims.as_json.flatten.sort_by { |claim| claim[:id] }
  end
end
