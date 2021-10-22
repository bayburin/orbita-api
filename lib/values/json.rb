class Json < Virtus::Attribute
  def coerce(value)
    value.is_a?(::Hash) || value.is_a?(ActionController::Parameters) ? value : JSON.parse(value)
  end
end
