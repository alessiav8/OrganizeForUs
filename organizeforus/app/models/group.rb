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

  }

  def has_partecipation?
    Partecipation.where(group_id: self.id).count!=0
  end
  #prima di eliminare un gruppo mi assicuro di aver eliminato ogni partecipazione per non violare la foreign key di partecipations
  def remove_partecipation
    Partecipation.where(group_id: self.id).destroy_all
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
    if has_driver?
        Member.where(group_id: self.id).where(driver: "t").take.user_email
    end
  end
  #


  validates :name, presence: true
  validates :description, presence: true
    
end
