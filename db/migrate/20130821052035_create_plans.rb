class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string   "usage"
      t.float   "price"
      t.boolean "is_active", :default => true      
      t.timestamps
    end
  end
end
