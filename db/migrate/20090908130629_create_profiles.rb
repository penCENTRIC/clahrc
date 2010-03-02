class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.references :user
      t.string     :prefix
      t.string     :first_name
      t.string     :middle_name
      t.string     :last_name
      t.string     :suffix
      t.string     :full_name
      t.string     :previous_full_name
      t.string     :nickname
      t.datetime   :date_of_birth
      t.string     :sex, :limit => 1, :default => ''
      t.text       :about
      t.timestamps
    end
    
    add_index :profiles, :user_id, :unique => true
  end

  def self.down
    drop_table :profiles
  end
end