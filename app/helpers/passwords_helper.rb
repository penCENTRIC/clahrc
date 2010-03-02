module PasswordsHelper
  def link_to_reset_password
    link_to 'Forgot your password?', new_password_path, :class => 'new password'
  end
end
