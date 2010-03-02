class GroupActivity < Activity
  def group
    trackable if trackable.is_a? Group
  end
end
