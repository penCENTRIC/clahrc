class AddPermalinkToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.string     :permalink
      t.index      :permalink
    end
  end

  def self.down
    remove_column :contents, :permalink
  end
end
