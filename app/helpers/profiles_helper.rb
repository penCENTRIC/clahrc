module ProfilesHelper
  def link_to_edit_profile
    link_to t('profiles.edit'), edit_my_profile_path, :class => 'edit profile'
  end
  
  def field_tag(label, value)
    %Q(<div class='field'><div class='label'>#{label}</div><div class='value'>#{value}</div></div>)
  end
  
  def profile_to_html(profile)
    unless profile.nil?
      returning(html = "") do
        unless profile.about.blank?
          html << %Q(<p>#{sanitize(profile.about)}</p>)
        end
        
        unless profile.activities.blank? || profile.interests.blank?
          html << %Q(<h2>Activities and Interests</h2>)
        end
        
        unless profile.activities.blank?
          html << field_tag('Activities:', links_to_tags(profile.activities))
        end

        unless profile.interests.blank?
          html << field_tag('Interests:', links_to_tags(profile.interests))
        end
      end
    end
  end
end
