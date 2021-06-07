require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  sign_in_user

  describe 'GET #init' do
    before do
      create_list(:admin, 3)
      create_list(:group, 2)
      create(:event_type, :open)
      create(:event_type, :workflow)
      create(:event_type, :add_workers)
      create(:event_type, :del_workers)
      create_list(:oauth_application, 3)

      get :init
    end


    it 'respond with users, groups and event_types keys' do
      expect(response.body).to have_json_path('init/users')
      expect(response.body).to have_json_path('init/groups')
      expect(response.body).to have_json_path('init/event_types')
      expect(response.body).to have_json_path('init/applications')
    end

    it 'load all users, groups and event_types' do
      expect(response.body).to have_json_size(4).at_path('init/users')
      expect(response.body).to have_json_size(6).at_path('init/groups')
      expect(response.body).to have_json_size(4).at_path('init/event_types')
      expect(response.body).to have_json_size(3).at_path('init/applications')
    end

    it 'respond with success status' do
      expect(response.status).to eq 200
    end
  end
end
