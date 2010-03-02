module OwnershipsHelper
  def link_to_group_ownerships(group)
    unless group.nil?
      link_to t('ownerships.index'), group_ownerships_path(group), :class => 'index ownerships'
    end
  end
end
