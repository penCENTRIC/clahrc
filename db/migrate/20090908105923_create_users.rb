class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string     :email, :null => false
      t.boolean    :confirmed, :default => false
      t.string     :crypted_password, :default => "", :null => false
      t.string     :password_salt, :default => "", :null => false
      t.string     :persistence_token, :null => false
      t.string     :single_access_token, :null => false
      t.string     :perishable_token, :null => false
      t.integer    :login_count, :null => false, :default => 0
      t.integer    :failed_login_count, :null => false, :default => 0
      t.datetime   :last_request_at
      t.datetime   :current_login_at
      t.datetime   :last_login_at
      t.string     :current_login_ip
      t.string     :last_login_ip
      t.integer    :contents_count, :default => 0
      t.integer    :comments_count, :default => 0
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
    add_index :users, :persistence_token, :unique => true
    add_index :users, :single_access_token, :unique => true
    add_index :users, :perishable_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end