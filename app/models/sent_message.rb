class SentMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  
  delegate :sender, :recipients, :subject_to_s, :body_to_html, :read, :to => :message
end
