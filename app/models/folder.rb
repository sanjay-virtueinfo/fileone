class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :folders, class_name: "Folder", foreign_key: :folder_id, :dependent => :destroy
  belongs_to :parent_folder, class_name: "Folder", foreign_key: :folder_id
  has_many :files, class_name: "Folder", conditions: {is_folder: false}, :dependent => :destroy
  #validates :name, :presence => true  
  
  scope :parent_folders, -> {where("folder_id IS NULL")}
  
  mount_uploader :file_path, ImageUploader
  
end
