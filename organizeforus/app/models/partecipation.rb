class Partecipation < ApplicationRecord
    belongs_to :user
    belongs_to :group

    before_destroy :cleanup_notification
    @list_role = Array.new

    scope :list_member, ->(group){
        arr=Array.new
        where(group_id: group).each do |member| 
          arr << User.find(member.user_id).email
        end
        return arr
    }

    scope :member, -> { where(:accepted => true) }

    validates :role, presence: true
    validates :user_id, presence: true

    def partecipations_number_for_survey(time,group)
      group.partecipations.where('created_at < ?', time).count
    end
    

  private 

  def cleanup_notification
    User.find(self.user_id).notifications.destroy_all
  end

    




end
