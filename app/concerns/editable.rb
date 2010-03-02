module Editable
  def self.included(base)
    def can_be_edited_by?(user)
      if self.user_id == user.id
        true
      elsif self.group.nil?
        false
      else
        self.group.moderators.include? user
      end
    end
  end
end