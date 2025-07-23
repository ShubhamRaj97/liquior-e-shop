class StoreUser < ApplicationRecord
  belongs_to :store
  belongs_to :user

   enum role: { manager: 'manager', staff: 'staff' }

  validates :role, presence: true
end
