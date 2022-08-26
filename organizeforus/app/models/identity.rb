class Identity < ApplicationRecord
    belongs_to :user, optional: true
    validates_uniqueness_of :uid, scope: [:provider]

    scope :get_provider_account , -> (user_id,provider) { where(user_id: user_id, provider: provider) }
end
