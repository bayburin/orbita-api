class AttachmentsQuery < ApplicationQuery
  def initialize(scope = Attachment.all)
    @scope = scope.extend(Scope)
  end

  def public
    scope.where(is_public: true)
  end
end
