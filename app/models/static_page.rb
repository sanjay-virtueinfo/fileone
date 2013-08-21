class StaticPage < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :page_route, :presence => true
	scope :footer, -> {where(:is_footer => true)}  
  
end
