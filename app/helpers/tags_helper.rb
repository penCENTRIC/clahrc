module TagsHelper
  def link_to_tag(tag)
    unless tag.nil?
      link_to tag.name.downcase, tag_path(tag), :class => 'tag'
    end
  end
  
  def links_to_tags(tags)
    unless tags.blank?
      tags.collect { |tag| link_to_tag tag }.to_sentence
    end
  end
end