require 'rails_helper'

RSpec.describe AttachmentForm, type: :model do
  let!(:attachment) { create(:attachment) }
  subject { described_class.new(attachment) }

  describe 'validations' do
    context 'when attachment is not file' do
      before { subject.validate(attachment: 'fake-string') }

      it { expect(subject.validate(attachment: 'fake-string')).to be_falsey }
      it { expect(subject.errors.messages).to include(:attachment) }
      it { expect(subject.errors.messages[:attachment]).to include('должен быть файл или должен быть файл') }
    end

    context 'when file size more than 50 megabytes' do
      let(:file) do
        ActionDispatch::Http::UploadedFile.new(
          filename: 'fake-file',
          type: 'text/plain',
          tempfile: File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))
        )
      end
      before do
        allow(file).to receive(:size).and_return(100.megabytes)
        subject.validate(attachment: file)
      end

      context 'and when it is a new form' do
        subject { described_class.new(Attachment.new) }

        it { expect(subject.validate(attachment: file)).to be_falsey }
        it { expect(subject.errors.messages).to include(:attachment) }
        it { expect(subject.errors.messages[:attachment]).to include('должен быть меньше или равен 50 МБ') }
      end

      context 'and when it is an existing form' do
        it { expect(subject.validate(attachment: file)).to be_truthy }
      end
    end
  end
end
