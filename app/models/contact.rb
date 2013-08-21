class Contact < ActiveRecord::Base
  scope :contactus, -> {where(:is_contact_us => true)}
  validates :name, :presence => true
  validates :email, :presence => true    
end
