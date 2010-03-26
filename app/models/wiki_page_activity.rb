class WikiPageActivity < ContentActivity
  def wiki_page
    trackable if trackable.is_a? WikiPage
  end
end
