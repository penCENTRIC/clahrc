module AvatarsHelper
  # Returns an html image tag for the user's avatar or gravatar
  def avatar_tag(user, options = {})
    unless user.nil? || user.new_record?
      options.symbolize_keys!
      options.reverse_merge! :title => user.name_to_s, :class => 'avatar'
    
      link_to avatar_image_tag(user, options), path_to_member(user), options
    end
  end

  def avatar_image_tag(user, options = {})
    options.symbolize_keys!
    options.reverse_merge! :style => :avatar

    options[:size] = case options[:style]
    when :original
      '550x550'
    when :medium
      '150x150'
    when :avatar
      '70x70'
    when :icon
      '30x30'
    end
    
    if user.avatar?
      img = image_tag(user.avatar.url(options.delete(:style)), options)
    else
      img = image_tag(user.gravatar_url, options)
    end
  end
    
  def link_to_edit_avatar
    link_to t('avatars.edit'), edit_my_avatar_path, :class => 'edit avatar'
  end
end
