class AdminController < ApplicationController
  
  # Uh-uh heroku says PAY!
  # force_ssl
  # Http basic authentication
  http_basic_authenticate_with :name => ENV['MD_USER'], :password => ENV['MD_PASS'], :realm => 'Molecular density'
  
end
