class Task < ApplicationRecord
    CALENDAR_ID = 'primary'
    belongs_to :user
  
end
