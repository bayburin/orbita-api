module ControllerMacros
  def sign_in_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:admin)
    end
  end

  def sign_in_employee
    let(:access_token) { create(:oauth_access_token) }
    let(:headers) { { Authorization: "Bearer #{access_token.token}" } }
    let!(:employee) { create(:employee) }
    before do
      request.headers.merge! headers
      allow(User).to receive(:authenticate_employee).and_return(employee)
    end
  end
end
