class UserSession < Authlogic::Session::Base
  def i18n_scope
    :activemodel
  end
end