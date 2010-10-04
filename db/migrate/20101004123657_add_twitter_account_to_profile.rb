class AddTwitterAccountToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :twitter, :string
  end

  def self.down
    remove_column :profiles, :twitter
  end
end