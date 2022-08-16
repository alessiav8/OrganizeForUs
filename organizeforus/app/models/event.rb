class Event < ApplicationRecord
  belongs_to :group
  belongs_to :user

  #accepts_nested_attributes_for :users, allow_destroy: true

end
