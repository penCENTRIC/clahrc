module UserSessionsHelper
  def link_to_login
    link_to t('login'), new_user_session_path, :title => t('login_title'), :class => 'new session'
  end

  def link_to_logout
    link_to t('logout'), user_session_path, :method => :delete, :title => t('logout_title'), :class => 'destroy session'
  end
  
  def session_links
    if current_user
      "Logged in as #{link_to current_user.name_to_s, my_account_path} (#{link_to_logout})"
    else
      "#{link_to_login} or #{link_to_register}"
    end
  end
end
