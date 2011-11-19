class AdminController < ApplicationController
  
  # Uh-uh heroku says PAY!
  # force_ssl
  # Http digest authentication
  REALM = 'moleculardensity'
  before_filter do |controller|
    unless authenticate_with_http_digest(REALM) { |username| username == ENV['MD_USER'] ? ENV['MD_PASS'] : nil }
      ActionController::HttpAuthentication::Digest.authentication_header(controller, REALM)
      message = '<img src="<%= asset_path "401.jpg" %>" alt="" width="400" height="400" />'
      controller.render :inline => message, :status => 401, :layout => "blog_error"
    end
  end
  
end
