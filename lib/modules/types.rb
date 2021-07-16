module Types
  include Dry.Types()

  Fio = String.constructor do |value|
    value.split(' ').map { |str1| str1.split('-').map { |str2| str2[0].upcase + str2[1..-1].downcase }.join('-') }.join(' ')
  end
  Email = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  SdService = Types.Constructor(ServiceDesk::Service)
  User = Types.Constructor(User)
  UploadedAttachment = Types.Instance(AttachmentUploader) | Types.Instance(ActionDispatch::Http::UploadedFile)
end
