class Question < ApplicationRecord
  belongs_to :survey
  has_many :answers, dependent: :destroy
  validates :title, presence: true



end
