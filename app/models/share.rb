class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder

  validates :shared_by, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Invalid email address' }
end
