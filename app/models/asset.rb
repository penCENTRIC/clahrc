class Asset < ActiveRecord::Base
  attr_accessible :data

  include Accessible
  
  belongs_to :user
  belongs_to :group

  has_one :clip, :dependent => :destroy
  has_one :content, :through => :clip
  
  has_attached_file :data, :url => '/:class/:id', :path => ':rails_root/:class/:id_partition/:basename.:extension'

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 10.megabytes
    
  def content_type
    data_content_type
  end

  def file_size
    data_file_size
  end

  def name
    data_file_name
  end

  def to_param
    unless new_record?
      param = name.mb_chars.normalize(:kd)

      param.gsub!(/[^\w -]+/n, '')  # strip unwanted characters
      param.strip!
      param.downcase!
      param.gsub!(/[ -]+/, '-')  # separate by single dashes

      "#{id}-#{param}"
    end
  end
  
  def url(*args)
    data.url(*args)
  end
  
  #require_dependency 'audio'
  #require_dependency 'image'
  #require_dependency 'video'
end
