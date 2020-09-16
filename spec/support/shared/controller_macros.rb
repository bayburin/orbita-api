module ControllerMacros
  def sign_in_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:admin)
    end
  end
end
