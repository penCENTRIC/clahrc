class AddPrivacyToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :private, :boolean, :default => false
    add_column :assets, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :assets, :private
    remove_column :assets, :hidden
  end
end
