class Group < ApplicationRecord
    #statement che associa un group all'utente che lo crea      
    belongs_to :user
    has_many :partecipations, dependent: :destroy
    has_many :surveys, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :events, dependent: :destroy

    has_one_attached :image, dependent: :destroy


    has_many :notifications, as: :recipient, dependent: :destroy
    has_noticed_notifications model_name: 'Notification'

    before_destroy :cleanup_notification
    before_destroy :remove_partecipation, if: :has_partecipation?


    validates :name, length: { minimum: 2 }
    validates :description, presence: true
    validates :date_of_start, presence: true
    validates :date_of_end, presence: true, comparison: { greater_than_or_equal_to: :date_of_start}
    validates :start_hour, presence: true
    validates :end_hour, presence: true, comparison: { greater_than_or_equal_to: :start_hour}
    validates :hours, presence: true

    
    scope :list_members, ->(group) {
      Partecipation.where(group_id: group)
    }

  scope :role_list, -> (group){
    array=Array.new
    if group.has_partecipation?
      Partecipation.where(group_id: group).each do |part|
        if part.role!='No Role' && (!array.include?(part.role))
           array << part.role
        end
      end
    end 
    return array
  }

  def list_accepted
    self.partecipations.member
  end

  def has_partecipation?
    Partecipation.where(group_id: self.id).count!=0
  end
  #prima di eliminare un gruppo mi assicuro di aver eliminato ogni partecipazione per non violare la foreign key di partecipations
  def remove_partecipation
    Partecipation.where(group_id: self.id).destroy_all
  end

  def remove_surveys
    if !self.surveys.empty?
       self.surveys.each{ |s|
        if !s.questions.empty?
          s.questions.each{|q|
            q.answers.destroy_all
          }
        end
      }
    end
  end

  def has_designeted_driver?
    Partecipation.where(group_id: self.id, role: 'Driver').count!=0
  end
  def delect_driver
    if self.has_designeted_driver?
      Partecipation.where(group_id:self.id, role: 'Driver').update(role: 'No Role')
    end
  end

  def delete_role(role)
   if has_partecipation?
    Partecipation.where(group_id:self.id, role: role).update(role: "No Role")
   end 
  end

  def created?
    self.created=="t"
  end

  def is_administrator?(user)
    if user==self.user 
      true
    elsif !Partecipation.find_by(group_id: self,user_id: user).nil?
      Partecipation.find_by(group_id: self,user_id: user).admin
    else
      false
    end
  end

  def administrator
    @administrator=User.find(self.user_id)
    return @administrator
  end

  def is_a_member?(user)
      if !Partecipation.where(group_id: self.id, user_id: User.where(email: user.email).take.id).empty?
        if self.accepted?(user.id)
          return true
        end
    end
    return false 
  end

  def accepted?(user)
    Partecipation.where(user_id: user,group_id: self.id).take.accepted==true
  end
  
  def has_member?
    Member.where(group_id: self.id).count!=0
  end
  def has_driver?
    Member.where(group_id: self.id).where.not(driver: "f").count!=0
  end

  def driver
    if has_designeted_driver?
      User.find(Partecipation.where(group_id: self.id, role: 'Driver').take.user_id).email
    end
  end
  #end 

  def exists?(group,role)
    !Partecipation.where(group_id:group, role: role).empty?
  end 

  def getColor(group,role)
    if exists?(group,role)
      color= Partecipation.where(group_id:group, role:role).first.role_color
      if color!=nil
        return color
      else 
        return 0
      end
    else 
      return 0 
    end 
  end

  def work?
    if self.work==true
      return true
    else
      return false
    end
  end
  
  

  def is_a_work_group
    if self.work == true
      return true
    end 
  end

  def start_time
    self.date_of_start ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end

  private 

  def cleanup_notification
    notifications_as_group.destroy_all
  end

    
  def readonly?
    false
  end

  def self.diff
    SecureRandom.hex(4)
  end



end