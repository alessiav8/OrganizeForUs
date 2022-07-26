class Survey < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :answers, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'



  before_destroy :cleanup_notification
  before_destroy :delete_questions_answers


  validates :title, presence: true, length: { minimum: 2 }

  scope :active, -> { where(:terminated => false) }


  def get_question_answers
    array=Array.new
    if !self.questions.empty?
      self.questions.each do |question|
        a=Array.new
        a << question.title
        a << question.answers.count
        array<<a 
      end
    end
    return array
  end
  
  private
  def cleanup_notification
    notifications_as_survey.destroy_all
  end

  def delete_questions_answers
    if !self.questions.empty?
      self.questions.each do |question|
        question.answers.destroy_all
      end
      self.questions.destroy_all
    end
  end




end
