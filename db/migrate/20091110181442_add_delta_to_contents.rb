class AddDeltaToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :contents, :delta
  end
end
