class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :user
      t.references :group
      t.references :commentable, :polymorphic => true
      t.string     :subject
      t.text       :body
      t.references :parent # acts_as_tree
      t.integer    :position, :default => 0 # acts_as_list
      t.timestamps
    end
    
    change_table :comments do |t|
      t.index      :user_id
      t.index      :group_id
      t.index      [ :commentable_type, :commentable_id ]
      t.index      :parent_id
    end
  end

  def self.down
    drop_table :comments
  end
end
