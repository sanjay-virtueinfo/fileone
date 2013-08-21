class Feature < ActiveRecord::Base
  belongs_to :plan
  validates :plan_id, :presence => true  
  scope :active, -> {where(:is_active => true)}
end
