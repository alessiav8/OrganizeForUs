class Group < ApplicationRecord
    #statement che associa un group all'utente che lo crea      
    belongs_to :user
    has_many :members
    has_many :roles
    has_many :partecipations
    has_many :notifications, as: :recipient, dependent: :destroy

    has_noticed_notifications model_name: 'Notification'

    before_destroy :cleanup_notification
    before_destroy :remove_partecipation, if: :has_partecipation?



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

  def has_partecipation?
    Partecipation.where(group_id: self.id).count!=0
  end
  #prima di eliminare un gruppo mi assicuro di aver eliminato ogni partecipazione per non violare la foreign key di partecipations
  def remove_partecipation
    Partecipation.where(group_id: self.id).destroy_all
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
    user==self.user
  end

  def is_a_member?(user)
      if !Partecipation.where(group_id: self.id, user_id: User.where(email: user.email).take.id).empty?
        if self.accepted?(user.id)
          return true
        end
    end 
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

  
  validates :name, presence: true
  validates :description, presence: true

  private 

  def cleanup_notification
    notifications_as_group.destroy_all
  end

    
end
