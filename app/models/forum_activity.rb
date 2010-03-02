class ForumActivity < ContentActivity
  def forum
    trackable if trackable.is_a? Forum
  end
end
