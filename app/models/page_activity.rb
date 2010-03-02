class PageActivity < ContentActivity
  def page
    trackable if trackable.is_a? Page
  end
end
