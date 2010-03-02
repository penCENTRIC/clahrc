module UsersHelper
  def link_to_register
    link_to t('register'), new_user_path, :title => t('register_title'), :class => 'new user'
  end
  
  def prepare_user(user)
    returning(user) do |u|
      u.build_profile if u.profile.nil?
    end
  end
end
