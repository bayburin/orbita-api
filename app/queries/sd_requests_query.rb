class SdRequestsQuery < ApplicationQuery
  def initialize(scope = SdRequest.all)
    @scope = scope.extend(Scope)
  end
end
