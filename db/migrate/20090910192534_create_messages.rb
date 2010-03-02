class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string     :type
      t.references :sender
      t.string     :subject
      t.text       :body
      t.references :parent # acts_as_tree
      t.timestamps
    end
    
    change_table :messages do |t|
      t.index :sender_id
      t.index :parent_id
    end
  end

  def self.down
    drop_table :messages
  end
end