# Создает форму вопроса и сохраняет в базе.
module Claims
  class Create
    include Interactor

    def call
      create_form = ClaimForm.new(context.claim || Claim.new)

      if create_form.validate(context.params) && create_form.save
        context.claim = create_form.model
      else
        context.fail!(errors: create_form.errors)
      end
    end
  end
end
