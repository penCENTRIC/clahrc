class ContentActivity < Activity
  def content
    trackable
  end
  
  require_dependency 'page_activity'
end
