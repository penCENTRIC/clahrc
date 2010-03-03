if RAILS_ENV == 'production'
  ActionController::Base.session = {
    :domain      => ENV['SESSION_DOMAIN'],
    :key         => ENV['SESSION_KEY'],
    :secret      => ENV['SESSION_SECRET']
  }
else
  ActionController::Base.session = {
    :domain      => '.clahrc.com',
    :key         => '_clahrc_session',
    :secret      => 'c07a714eb4968290551e20b95eb05491f570b2ffb05a07f44dec56ba75d2187cab46db4b41d312da4873adca165caa98b78727a0ccdffa324a342d0a7b28add7'
  }  
end
