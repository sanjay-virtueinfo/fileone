class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :user
      t.references :folder
      t.string :shared_by
      t.timestamps
    end
  end
end
