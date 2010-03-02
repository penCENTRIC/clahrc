module Clipable
  def self.included(base)
    base.attr_accessible :new_asset_attributes, :existing_asset_attributes
    base.has_many :clips, :foreign_key => 'content_id', :dependent => :destroy
    base.has_many :assets, :through => :clips
    #base.validates_associated :assets
    
    def new_asset_attributes=(asset_attributes) 
      asset_attributes.each do |attributes|
        asset = assets.build(:data => attributes[:data])

        asset.user_id = user_id
        asset.group_id = group_id
        asset.access = access
      end
    end

    def existing_asset_attributes=(asset_attributes)
      assets.reject(&:new_record?).each do |asset|      
        attributes = asset_attributes[asset.to_param]
        
        if attributes
          asset.attributes = { :data => attributes[:data] }

          asset.user_id = user_id
          asset.group_id = group_id
          asset.access = access
        else
          asset.delete 
        end
      end
    end
  end
end
