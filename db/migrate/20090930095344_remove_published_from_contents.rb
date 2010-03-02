class RemovePublishedFromContents < ActiveRecord::Migration
  def self.up
    remove_column :contents, :published
    remove_column :contents, :published_at
  end

  def self.down
    add_column :contents, :published
    add_column :contents, :published_at
    
    Content.all.each { |c| c.published = true; c.published_at = c.created_at; c.save }
  end
end
