class CreateUserPlans < ActiveRecord::Migration
  def change
    create_table :user_plans do |t|
      t.references :user
      t.references :plan
      t.string :invoice_number
      t.string :email
      t.datetime :start_date
      t.datetime :expire_date
      t.integer :amount, :default => 0
      t.string :verification_method
      t.boolean :is_verified, :default => true
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
