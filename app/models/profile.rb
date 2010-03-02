class Profile < ActiveRecord::Base
  attr_accessible :prefix, :first_name, :middle_name, :last_name, :suffix, :previous_full_name, :nickname, :date_of_birth, :sex, :about, :skype
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  belongs_to :user
  
  acts_as_taggable_on :activities, :interests
  attr_accessible :activity_list, :interest_list
  
  def helpers
    ActionController::Base.helpers
  end  
  
  delegate :sanitize, :textilize, :to => :helpers
  
  def about_to_html
    textilize(about.to_s)
  end
  
  protected
    def before_save
      self.full_name = Hpricot([ self.prefix, self.first_name, self.middle_name, self.last_name, self.suffix ].reject { |e| e.blank? }.join(' ')).inner_text
    end 
end
