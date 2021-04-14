module Astraea
  # Класс преобразует json-объект, полученные из Astraea в json-объект, необходимый для создания заявки.
  class SdRequestAdapter
    attr_reader :sd_request_params, :params

    def initialize(params)
      @sd_request_params = SdRequests::CreateForm.new(SdRequest.new).as_json['fields'].symbolize_keys
      @sd_request_params[:source_snapshot] = SdRequests::SourceSnapshotForm.new(SourceSnapshot.new).as_json['fields'].symbolize_keys
      @params = params

      processing_params
    end

    protected

    # TODO: Проверить, каких отрибутов может не хватать
    def processing_params
      sd_request_params[:id] = params[:case_id]
      sd_request_params[:description] = params[:desc]
      sd_request_params[:service_id] = params[:service_id]
      sd_request_params[:source_snapshot][:svt_item_id] = params[:item_id]
      sd_request_params[:source_snapshot][:user_attrs] = { work_tel: params[:phone] }
      sd_request_params[:finished_at_plan] = Time.zone.at(params[:time])

      load_user_data if params[:user_tn]
      build_works if params[:users]
    end

    def load_user_data
      employee_info = Employees::Loader.new(:by_tn).load([params[:user_tn]])

      if employee_info
        sd_request_params[:source_snapshot][:id_tn] = employee_info['data'].first['id']
      end
    end

    def build_works
      user_groups = User.where(tn: params[:users].map { |u| u[:user_id] }).group_by { |u| u.group_id }

      user_groups.each do |group_id, users|
        sd_request_params[:works] << { group_id: group_id, workers: users.map { |u| { worker_id: u.id } } }
      end
    end
  end
end
