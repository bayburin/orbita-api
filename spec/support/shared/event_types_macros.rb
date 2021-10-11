module EventTypesMacros
  def create_event_types
    before do
      create(:event_type, :open)
      create(:event_type, :workflow)
      create(:event_type, :comment)
      create(:event_type, :add_workers)
      create(:event_type, :del_workers)
      create(:event_type, :escalation)
      create(:event_type, :postpone)
      create(:event_type, :close)
      create(:event_type, :add_files)
      create(:event_type, :add_tags)
      create(:event_type, :priority)
      create(:event_type, :add_self)
    end
  end
end
