class Answer < ApplicationRecord
  belongs_to :survey
  has_one :question
  has_one :user
end
