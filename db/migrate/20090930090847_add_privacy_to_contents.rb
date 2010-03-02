class AddPrivacyToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :private, :boolean, :default => false
    add_column :contents, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :contents, :private
    remove_column :contents, :hidden
  end
end
