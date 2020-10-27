# module Histories
#   # Создает запись истории о событии с типом "add_self".
#   class CreateAddSelf
#     include Interactor

#     delegate :skip_history, :event, :history, to: :context

#     def call
#       return if skip_history

#       context.history = event.work.histories.build(
#         event_type: event.event_type,
#         user: event.user,
#         action: event.event_type.template
#       )

#       context.fail!(error: history.errors.full_messages) unless history.save
#     end
#   end
# end
