class ClaimsQuery < ApplicationQuery
  def initialize(scope = Claim.all)
    @scope = scope.extend(Scope)
  end

  def search_into_ticket_identity(identity, app_id, int_id)
    scope.by_ticket_identity(identity).by_app_integration(app_id, int_id)
  end

  def search_by_integration(app_id, int_id)
    scope.by_app_integration(app_id, int_id)
  end
end
