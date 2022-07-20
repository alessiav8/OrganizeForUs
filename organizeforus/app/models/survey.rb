class Survey < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true



  validates :title, presence: true, length: { minimum: 2 }

  scope :active, -> { where(:terminated => false) }

end
