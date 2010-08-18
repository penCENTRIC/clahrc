Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static', :urls => [ '/stylesheets' ], :root => "#{Rails.root}/tmp")
