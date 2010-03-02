class CreateClips < ActiveRecord::Migration
  def self.up
    create_table :clips do |t|
      t.references :content
      t.references :asset
      t.timestamps
    end
    
    change_table :clips do |t|
      t.index [ :content_id, :asset_id ]
    end
  end

  def self.down
    drop_table :clips
  end
end
