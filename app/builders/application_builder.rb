class ApplicationBuilder
  attr_reader :model

  def self.build(params = {})
    builder = new
    yield(builder) if block_given?

    params.each do |attr_name, attr_val|
      if builder.respond_to?("#{attr_name}=")
        builder.send("#{attr_name}=", attr_val)
      elsif builder.model.respond_to?(attr_name)
        builder.model.send("#{attr_name}=", attr_val)
      end
    end

    builder.model
  end
end
