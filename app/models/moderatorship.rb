class Moderatorship < Membership
  def promote!
    update_attribute :type, 'Ownership'
  end

  require_dependency 'ownership'
end
