class Survey < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :answers

  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'



  before_destroy :cleanup_notification


  validates :title, presence: true, length: { minimum: 2 }

  scope :active, -> { where(:terminated => false) }


  private
  def cleanup_notification
    notifications_as_survey.destroy_all
  end

end
