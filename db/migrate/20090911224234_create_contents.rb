class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string     :type
      t.references :user
      t.references :group
      t.string     :title
      t.text       :body
      t.boolean    :published, :default => true
      t.datetime   :published_at
      t.boolean    :comments_enabled, :default => true
      t.integer    :comments_count, :default => 0
      t.references :parent, :polymorphic => true # acts_as_tree
      t.integer    :position, :default => 0 # acts_as_list
      t.timestamps
    end

    change_table :contents do |t|
      t.index      :user_id
      t.index      :group_id
      t.index      [ :parent_id, :parent_type ]
    end
  end

  def self.down
    drop_table :contents
  end
end
