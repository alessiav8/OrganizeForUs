class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many_attached :files, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'

  before_destroy :cleanup_notification

  private 

  def cleanup_notification
    notifications_as_post.destroy_all
  end

  validates :title, presence: true
  validates :body, length: { minimum: 2 }
end
