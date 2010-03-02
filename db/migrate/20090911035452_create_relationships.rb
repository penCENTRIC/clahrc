class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.string     :type
      t.references :user
      t.references :relatable, :polymorphic => true
      t.boolean    :confirmed, :default => false
      t.references :request
      t.timestamps
    end
    
    change_table :relationships do |t|
      t.index [ :type, :user_id, :relatable_type, :relatable_id ], :name => :unique_relationship, :unique => true
    end
  end

  def self.down
    drop_table :relationships
  end
end
