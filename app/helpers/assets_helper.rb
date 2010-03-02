module AssetsHelper
  def link_to_add_asset 
    link_to_function t('assets.add') do |page| 
      page.insert_html :bottom, :assets, :partial => 'pages/asset', :object => Asset.new 
    end 
  end
  
  def link_to_destroy_asset(asset)
    unless asset.nil?
      link_to t('assets.destroy'), path_for_asset(asset), :class => 'destroy asset', :confirm => 'Are you sure?', :method => :delete
    end
  end

  def link_to_edit_asset(asset)
    unless asset.nil?
      link_to t('assets.edit'), path_for_edit_asset(asset), :class => 'edit asset'
    end
  end
  
  def link_to_new_asset(parent = current_user)
    link_to t('assets.new'), path_for_new_asset(parent), :class => 'new asset'
  end

  def link_to_asset(asset, options = {})
    link_to asset.name, path_for_asset(asset), :class => 'show asset'
  end

  def link_to_assets(parent = current_user)
    link_to t('assets.index'), path_for_assets(parent), :class => 'index asset'
  end
  
  def links_to_assets(parent, assets)
    returning(html = "") do
      html << %Q(<ul>)
      
      assets.each do |asset|
        html << %Q(<li>#{link_to_asset(asset)}</li>)
      end
      
      html << %Q(<li class='silver'>#{link_to 'More files...', path_for_assets(parent)}</li>)
      
      html << %Q(</ul>)
    end
  end
      
  def asset_teaser(asset, options = {})
    unless asset.nil?
      options.symbolize_keys!
      options.reverse_merge! :url => path_for_asset(asset)
    
      content_teaser asset, options
    end
  end
  
  def path_for_edit_asset(asset)
    if asset.user_id && asset.user_id == current_user.id
      my_asset_path(asset, :anchor => 'edit')
    else
      asset_path(asset, :anchor => 'edit')
    end
  end
  
  def path_for_new_asset(parent)
    case parent
    when Group
      new_group_asset_path(parent)
    when User
      if parent.id == current_user.id
        new_my_asset_path
      else
        new_member_asset_path(parent)
      end
    else
      nil
    end
  end

  def path_for_asset(asset)
    if asset.group_id.nil? && asset.user_id && asset.user_id == current_user.id
      my_asset_path(asset)
    else
      asset_path(asset)
    end
  end
  
  def path_for_assets(parent)
    case parent
    when Group
      group_assets_path(parent)
    when User
      if parent.id == current_user.id
        my_assets_path
      else
        member_assets_path(parent)
      end
    else
      nil
    end
  end
end
