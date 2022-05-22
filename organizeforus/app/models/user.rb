class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  #statement che associa un user a più gruppi          
  has_many :groups
  

  #Valido la presenza e l'unicità dei campi dell'utente:
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true
end
