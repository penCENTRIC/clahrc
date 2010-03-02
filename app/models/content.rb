class Content < ActiveRecord::Base
  attr_accessible :user_id, :group_id, :title, :body

  validates_presence_of :title
  validates_presence_of :body
  
  belongs_to :user
  belongs_to :group
  
  include Accessible
  include Destroyable
  include Editable
  include Trackable
    
  def helpers
    ActionController::Base.helpers
  end  

  delegate :sanitize, :to => :helpers
 
  define_index do
    indexes :title
    indexes :body
    
    has 'IF(hidden, user_id, NULL)', :as => :owner_id, :type => :integer
    has 'IF(hidden, NULL, IF(private, user_id, 0))', :as => :owner_ids, :type => :integer
    has 'IF(group_id, group_id, 0)', :as => :group_ids, :type => :integer
    
    set_property :delta => true
  end
    
  def body_to_html
    RedCloth.new(body.to_s).extend(RedCloth::Extensions).to_html
  end
  
  def title_to_s
    sanitize(title.to_s)
  end

  # Permalink slug
  def to_param
    param = title_to_s.mb_chars.normalize(:kd)

    param.gsub!(/[^\w -]+/n, '')  # strip unwanted characters
    param.strip!
    param.downcase!
    param.gsub!(/[ -]+/, '-')  # separate by single dashes

    "#{id}-#{param}"
  end
  
  class << self
    def order(ids)
      ids.each_index do |index|
        update ids[index], :position => index
      end
    end
  end
  
  require_dependency 'forum'
  require_dependency 'page'
  require_dependency 'post'
  require_dependency 'topic'
end
