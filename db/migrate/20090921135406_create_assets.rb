class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string     :type
      t.references :user
      t.references :group
      t.string     :data_file_name
      t.string     :data_content_type
      t.integer    :data_file_size
      t.timestamps
    end
    
    change_table :assets do |t|
      t.index      :user_id
      t.index      :group_id
    end
  end

  def self.down
    drop_table :assets
  end
end
