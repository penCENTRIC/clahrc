class AddFieldsToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :location, :string
    add_column :profiles, :employer, :string
    add_column :profiles, :projects, :text
    add_column :profiles, :work_phone, :string
    add_column :profiles, :work_email, :string
  end

  def self.down
    remove_column :profiles, :location
    remove_column :profiles, :employer
    remove_column :profiles, :projects
    remove_column :profiles, :work_phone
    remove_column :profiles, :work_email
  end
end