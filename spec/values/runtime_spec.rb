require 'rails_helper'

RSpec.describe Runtime do
  let(:time) { Time.zone.now }
  let(:attrs) { { finished_at_plan: time } }
  subject { described_class.new(attrs) }

  it { expect(subject.finished_at_plan_str).to eq time.strftime("#{described_class::DATE_FORMAT} #{described_class::TIME_FORMAT}") }
end
