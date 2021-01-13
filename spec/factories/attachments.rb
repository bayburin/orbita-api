FactoryBot.define do
  factory :attachment do
    claim { build(:claim) }
    attachment { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'uploads', 'test_file.txt'))) }
  end
end
