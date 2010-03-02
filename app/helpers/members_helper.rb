module MembersHelper
  def member_teaser(member, options = {})
    unless member.nil?
      returning(html = "") do
        if member.profile.blank? || member.profile.about.blank?
          # do nothing
        else
          doc = Hpricot(member.profile.about_to_html)

          if p = (doc/'p').first
            html << sanitize(p.to_html)
          else
            html << sanitize(doc.to_html)
          end
        end
      end      
    end
  end
    
  def link_to_destroy_member
    link_to t('members.destroy'), member_path(member), :class => 'destroy member', :confirm => 'true', :method => :delete
  end
  
  def link_to_edit_member(member)
    link_to t('members.edit'), edit_member_path(member), :class => 'edit member'
  end
  
  def link_to_member(member, options = {})
    unless member.nil?
      options.symbolize_keys!
      options.reverse_merge! :class => 'member', :url => path_to_member(member)
      
      if query = options.delete(:query)
        link_to member.excerpts.full_name, options.delete(:url), options
      else
        link_to member.name_to_s, options.delete(:url), options
      end
    end
  end

  def link_to_members
    link_to t('members.index'), members_path, :class => 'index member'
  end
  
  def links_to_members(members)
    unless members.blank?
      members.collect { |member| link_to_member member }.to_sentence
    end
  end
    
  def link_to_members_directory
    link_to t('members.directory'), directory_members_path(:directory_id => 1), :class => 'index member'
  end
  
  def possesive(name)
    if name =~ /s$/
      "#{name}'"
    else
      "#{name}'s"
    end
  end
  
  def path_to_member(member)
    if member == current_user
      my_account_path
    else
      member_path(member)
    end
  end
end
