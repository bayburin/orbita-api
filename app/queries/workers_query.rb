class WorkersQuery < ApplicationQuery
  def initialize(scope = Worker.all)
    @scope = scope.extend(Scope)
  end

  def search_workers_into_claim(claim, users)
    scope.joins(:work).where(works: { claim: claim }, user: users)
  end
end
