class PostActivity < ContentActivity
  def post
    trackable if trackable.is_a? Post
  end
end
