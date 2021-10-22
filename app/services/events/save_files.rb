module Events
  # Сохраняет файлы на основании полученного события Event.
  class SaveFiles
    include Interactor

    delegate :event, :history_store, :attachments, to: :context

    def call
      context.attachments = event.claim.attachments.build(
        event.files.map { |file| { attachment: file, is_public: event.payload['is_public'] } }
      )
      attachments.each { |attachment| history_store.add_to_combine(:add_files, attachment.attachment.filename) }

      if attachments.any? { |attach| attach.invalid? }
        context.fail!(error: attachments.flat_map { |attach| attach.errors.full_messages })
      else
        attachments.each(&:save)
        history_store.save!
        SdRequests::BroadcastUpdatedRecordWorker.perform_async(event.claim.id)
      end
    end
  end
end
