module ModeratorshipsHelper
  def link_to_group_moderatorships(group)
    unless group.nil?
      link_to t('moderatorships.index'), group_moderatorships_path(group), :class => 'index moderatorships'
    end
  end
  
  def link_to_promote_moderatorship(moderatorship)
    unless moderatorship.nil?
      link_to t('moderatorships.promote'), promote_group_moderatorship_path(:group_id => moderatorship.group, :id => moderatorship), :class => 'promote moderatorship', :method => :put
    end
  end  
end
