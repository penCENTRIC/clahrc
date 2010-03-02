module ActivitiesHelper
  def link_to_destroy_activity(activity)
    unless activity.nil?
      link_to t('activities.destroy'), path_for_activity(activity), :class => 'destroy activity', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_activity(activity)
    unless activity.nil?
      link_to t('activities.edit'), path_for_edit_activity(activity), :class => 'edit activity'
    end
  end
  
  def link_to_new_activity(parent = current_user)
    link_to t('activities.new'), path_for_new_activity(parent), :class => 'new activity'
  end

  def link_to_activity(activity, options = {})
    unless activity.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'show activity', :url => path_for_activity(activity)
      
      link_to_content activity, options
    end
  end

  def link_to_activities(parent = current_user)
    link_to t('activities.index'), path_for_activities(parent), :class => 'index activity'
  end
  
  def links_to_activities(parent, activities)
    returning(html = "") do
      html << %Q(<ul>)
      
      activities.each do |activity|
        html << %Q(<li>#{link_to_activity(activity)}</li>)
      end
      
      html << %Q(<li class='silver'>#{link_to 'More activities...', path_for_activities(parent)}</li>)
      
      html << %Q(</ul>)
    end
  end
      
  def activity_teaser(activity, options = {})
    unless activity.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_activity(activity)
    
      content_teaser activity, options
    end
  end
  
  def path_for_edit_activity(activity)
    if activity.user_id && activity.user_id == current_user.id
      my_activity_path(activity, :anchor => 'edit')
    else
      activity_path(activity, :anchor => 'edit')
    end
  end
  
  def path_for_new_activity(parent)
    case parent
    when Group
      new_group_activity_path(parent)
    when User
      if parent.id == current_user.id
        new_my_activity_path
      else
        new_member_activity_path(parent)
      end
    else
      nil
    end
  end

  def path_for_activity(activity, options = {})
    if activity.group_id.nil? && activity.user_id && activity.user_id == current_user.id
      my_activity_path(activity, options)
    else
      activity_path(activity, options)
    end
  end
  
  def path_for_activities(parent)
    case parent
    when Group
      group_activities_path(parent)
    when User
      if parent.id == current_user.id
        my_activities_path
      else
        member_activities_path(parent)
      end
    else
      nil
    end
  end
end
