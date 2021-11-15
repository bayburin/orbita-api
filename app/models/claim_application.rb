class ClaimApplication < ApplicationRecord
  belongs_to :claim
  belongs_to :application, class_name: 'Doorkeeper::Application'
end
