class User < ActiveRecord::Base
	
	include ActionView::Helpers::TextHelper
	
  acts_as_authentic do |c|
    c.login_field = 'email'
  end
  
  attr_writer :password_required

  validates_presence_of :password, :if => :password_required?

  def password_required?
    @password_required
  end    
  
	validates_uniqueness_of :email
	validates :email, :presence => true
	has_one :user_role, :dependent => :destroy
	has_one :role, :through => :user_role
	has_many :parent_folders, class_name: "Folder", foreign_key: :folder_id, conditions: {is_folder: true}
	has_many :shares
	has_many :plans
	
  scope :active, -> {where(:is_active => true)}
  scope :all_users, joins(:role).where(:roles => { :role_type => "User" })
  
  mount_uploader :image, ImageUploader
 
	def user_name
		return self.first_name.blank? ? self.username : (self.first_name.to_s + " " + self.last_name.to_s)
	end
	
  def has_role?(role)
    self.user_role.role.role_type == role
  end
  
  def is_super_admin?
    has_role?("SuperAdmin")
  end
  
  def is_user?
    has_role?("User")
  end
 
  def name(shorten=true)
    unless first_name.nil? && last_name.nil? or first_name.empty? && last_name.empty?
      [first_name, last_name].join(" ")
    else
      shorten ? truncate(email, :omission => "..", :length => 20) : email
    end
  end  

  def user_name(shorten=true)
    unless first_name.nil? && last_name.nil? or first_name.empty? && last_name.empty?
      [first_name, last_name].join("-")
    else
      shorten ? truncate(email, :omission => "..", :length => 20) : email
    end
  end 
  	
end
