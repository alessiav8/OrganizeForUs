class Group < ApplicationRecord
    #statement che associa un group all'utente che lo crea      
    belongs_to :user
    has_many :members
    has_many :roles
    has_many :partecipations

    before_destroy :remove_partecipation, if: :has_partecipation?


  scope :list_members, ->(group) {
    Partecipation.where(group_id: group)
  }

  scope :role_list, -> (group){
    array=Array.new
    if group.has_partecipation?
      Partecipation.where(group_id: group).each do |part|
        array << part.role
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
      Partecipation.where(group_id:self.id, role: 'Driver').update(role: ' ')
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

  def set_created
    Group.where(id: self.id).update(created: "t")
  end




  #da cancellare
  scope :list_member, ->(group) {
    arr=Array.new
    arr << 'Select Driver'
    Member.where(group_id: group).each do |member| 
      arr << member.name
    end
    return arr
  }
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
  #


  validates :name, presence: true
  validates :description, presence: true
    
end
