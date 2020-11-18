module Applications
  # Создает форму вопроса и сохраняет в базе.
  class Create
    include Interactor

    def call
      create_form = ApplicationForm.new(context.application || Application.new)

      if create_form.validate(context.params.merge(source_snapshot: {})) && create_form.save
        context.application = create_form.model
      else
        context.fail!(errors: create_form.errors)
      end
    end
  end
end
