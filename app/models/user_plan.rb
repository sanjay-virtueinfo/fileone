class UserPlan < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  validates :plan_id, :presence => true
  validates :user_id, :presence => true
  scope :active, -> {where(:is_active => true)}
  scope :verified, -> {where(:is_verified => true)}
end
