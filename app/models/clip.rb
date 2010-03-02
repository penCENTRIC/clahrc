class Clip < ActiveRecord::Base
  belongs_to :asset
  belongs_to :content
end
