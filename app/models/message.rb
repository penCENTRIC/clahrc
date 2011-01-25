class Message < ActiveRecord::Base
  attr_accessible :subject, :body
  
  validates_presence_of :sender
  validates_presence_of :subject
  validates_presence_of :body
  
  # Sender
  belongs_to :sender, :class_name => 'User'
  
  # Recipients
  has_many :message_recipients, :dependent => :destroy
  has_many :recipients, :through => :message_recipients
  
  has_many :sent_messages, :dependent => :destroy
  has_many :received_messages, :dependent => :destroy
    
  def from(sender)
    returning(self) do
      self.sender = sender
    end
  end
  
  delegate :sanitize, :textilize, :to => :helpers

  def body_to_s
    Hpricot(body_to_html).inner_text
  end
  
  def body_to_html
    textilize(body.to_s)
  end
  
  def subject_to_s
    sanitize(subject.to_s)
  end

  def helpers
    ActionController::Base.helpers
  end  
  
  def to(recipients)
    returning(self) do
      self.recipients = [ recipients ].flatten.uniq
    end
  end
  
  include Trackable

end
