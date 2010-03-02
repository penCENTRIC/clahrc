class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.references :tag
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true
      t.string     :context
      t.timestamps
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [ :taggable_id, :taggable_type, :context ]
  end
  
  def self.down
    drop_table :taggings
  end
end
