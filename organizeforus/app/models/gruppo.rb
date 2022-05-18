class Gruppo < ApplicationRecord
    #statement che associa un gruppo all'utente che lo crea      
    belongs_to :user
    has_many :members
end
