module AccountsHelper
  def link_to_edit_account
    link_to t('accounts.edit'), edit_my_account_path, :class => 'edit account'
  end

  def link_to_account
    link_to current_user.name_to_s, my_account_path
  end
  
  def link_to_home
    link_to t('home'), current_user ? my_activity_path : 'http://clahrc.net/'
  end
end
