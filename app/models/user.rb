class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  include Authentic
  include Avatar
  
  def helpers
    ActionController::Base.helpers
  end  

  delegate :sanitize, :textilize, :to => :helpers

  def all_group_ids
    self.group_ids + self.invited_group_ids
  end
  
  def name_to_s
    sanitize(full_name || nickname || email.split('@'))
  end

  def body_to_html
    textilize(profile.about)
  end
   
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
  
  def can_edit?(resource)
    resource.respond_to?(:can_be_edited_by?) && resource.can_be_edited_by?(self)
  end
  
  # Assets
  has_many :assets
  
  # Friends
  has_many :friendships, :as => :relatable, :conditions => { :confirmed => true }, :dependent => :destroy
  has_many :friends, :through => :friendships, :source => :user
      
  has_many :pending_friendships, :as => :relatable, :class_name => 'Friendship', :conditions => { :confirmed => false }
  has_many :pending_friends, :through => :pending_friendships, :source => :user
  
  # Memberships
  has_many :memberships, :conditions => { :confirmed => true }, :dependent => :destroy
  has_many :groups, :through => :memberships, :source => :relatable
  
  # Invitations
  has_many :invited_memberships, :dependent => :destroy
  has_many :invited_groups, :through => :invited_memberships, :source => :relatable
  
  # Profile
  has_one :profile
  
  accepts_nested_attributes_for :profile
  attr_accessible :profile_attributes
  
  delegate :full_name, :nickname, :sex, :to => :profile
  
  def male?
    sex.upcase == 'M'
  end
  
  def female?
    sex.upcase == 'F'
  end
  
  # Messages
  has_many :sent_messages, :dependent => :destroy
  has_many :received_messages, :dependent => :destroy
  has_many :unread_messages, :through => :received_messages, :source => :message, :conditions => { :received_messages => { :read => false } }
  
  # Activities
  has_many :activities
  
  # Content
  has_many :pages
  has_many :posts
  
  define_index do
    indexes profile(:full_name), :as => :full_name
    indexes profile(:previous_full_name), :as => :previous_full_name
    indexes profile(:about), :as => :about

    set_property :delta => true
  end
end