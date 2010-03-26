class Group < ActiveRecord::Base
  attr_accessible :name, :description
  
  include Accessible
  
  validates_presence_of :name
  validates_presence_of :description
  
  has_many :tracked_activities, :class_name => 'Activity', :as => :trackable
  before_save :track_changes
  
  def track_changes
    @tracked_changes = changes.reject { |key, value| [ 'id', 'created_at', 'updated_at' ].include?(key.to_s) }
  end
  
  def tracked_changes
    @tracked_changes
  end

  define_index do
    indexes :name
    indexes :description
    
    set_property :delta => true
  end
  
  # Avatar
  has_attached_file :avatar, {
    :url => '/:attachment/:class/:id_partition/:style.:extension',
    :styles => {
      :original => [ '550x550#', :png ],
      :medium => [ '150x150#', :png ],
      :avatar => [ '70x70#', :png ], 
      :icon => [ '30x30#', :png ]
    }
  }

  attr_accessible :avatar

  validates_attachment_content_type :avatar, :content_type => [ 'image/gif', 'image/jpeg', 'image/png' ]
  validates_attachment_size :avatar, :less_than => 1.megabytes  
  
  # Gravatar support
  has_gravatar :default => 'identicon'
  
  # Interests and activities
  acts_as_taggable_on :activities, :interests
  attr_accessible :activity_list, :interest_list
  
  def email
    to_param
  end
  
  def helpers
    ActionController::Base.helpers
  end  

  delegate :sanitize, :textilize, :to => :helpers

  def description_to_html
    textilize(description.to_s)
  end
  
  def name_to_s
    sanitize(name)
  end
  
  # Assets
  has_many :assets
  
  # Invitations
  has_many :invited_memberships, :as => :relatable, :conditions => { :confirmed => false }, :dependent => :destroy
  has_many :invited_members, :through => :invited_memberships, :source => :user
  
  # Memberships
  has_many :memberships, :as => :relatable, :conditions => { :confirmed => true }, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :pending_memberships, :as => :relatable, :class_name => 'Membership', :conditions => { :confirmed => false }, :dependent => :destroy
  has_many :pending_members, :through => :pending_memberships, :source => :user
  
  # Moderatorships
  has_many :moderatorships, :as => :relatable, :conditions => { :confirmed => true }
  has_many :moderators, :through => :moderatorships, :source => :user

  # Ownerships
  has_many :ownerships, :as => :relatable, :conditions => { :confirmed => true }
  has_many :owners, :through => :ownerships, :source => :user
  
  # Content
  has_many :forums
  has_many :pages
  has_many :wiki_pages
  
  def to_param
    unless new_record?
      param = name_to_s.mb_chars.normalize(:kd)

      param.gsub!(/[^\w -]+/n, '')  # strip unwanted characters
      param.strip!
      param.downcase!
      param.gsub!(/[ -]+/, '-')  # separate by single dashes

      "#{id}-#{param}"
    end
  end
  
  def can_be_edited_by?(user)
    self.moderators.include? user
  end
end
