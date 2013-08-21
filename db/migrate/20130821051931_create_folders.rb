class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.references :user
      t.references :folder
      t.string :name
      t.string :file_path
      t.string :file_name
      t.string :file_content_type
      t.float :file_size, :default => 0
      t.string :amazon_file_path
      t.boolean :is_folder, :default => true     
      
      t.timestamps
    end
  end
end
