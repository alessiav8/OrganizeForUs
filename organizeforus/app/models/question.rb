class Question < ApplicationRecord
  belongs_to :survey
  has_many :answers
  
  validates :title, presence: true
end
