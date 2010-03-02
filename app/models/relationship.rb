class Relationship < ActiveRecord::Base
  include Trackable
  
  belongs_to :user
  belongs_to :relatable, :polymorphic => true

  # Accept the relationship
  def accept!
    update_attribute :confirmed, true
  end

  # Reject the relationship
  def reject!
    destroy
  end

  require_dependency 'friendship'
  require_dependency 'membership'  
end
