require 'reform/form/dry'
require 'reform/form/coercion'

Reform::Form.class_eval do
  include Reform::Form::Dry
end
