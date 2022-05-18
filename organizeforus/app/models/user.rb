class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :groups


  #Valido la presenza e l'unicità dei campi dell'utente:
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, presence: true, uniqueness: true
  validates :birthday, presence: true

  #validates_presence_of :name,:message => "Please Provide User Name"
  #validates_presence_of :surname,:message => "Please Provide User Surname"
end
