class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :text, presence: true, length: { minimum: 10 }

end
