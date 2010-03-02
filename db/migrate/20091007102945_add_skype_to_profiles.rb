class AddSkypeToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :skype, :string
  end

  def self.down
    remove_column :profiles, :skype
  end
end
