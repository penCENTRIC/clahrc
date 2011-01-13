class User
  include Gravtastic
  
  module Avatar
    def self.included(base)
      base.has_attached_file :avatar, {
        :url => '/:attachment/:class/:id_partition/:style.:extension',
        :styles => {
          :original => [ '550x550#', :jpg ],
          :medium => [ '150x150#', :jpg ],
          :avatar => [ '70x70#', :jpg ], 
          :icon => [ '30x30#', :jpg ]
        }
      }

      base.attr_accessible :avatar

      base.validates_attachment_content_type :avatar, :content_type => [ 'image/gif', 'image/jpeg', 'image/pjpeg', 'image/png' ]
      base.validates_attachment_size :avatar, :less_than => 2.megabytes

      # Gravatar support
      base.has_gravatar :default => 'identicon'
    end
  end
end