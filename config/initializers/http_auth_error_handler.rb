ActionController::HttpAuthentication::Basic.module_eval do
  def authentication_request(controller, realm)
    controller.headers["WWW-Authenticate"] = %(Basic realm="#{realm.gsub(/"/, "")}")
    message = '<div style="padding:60px 20px 60px 20px; font-style:italic;"><span>Who the fuck are you?</span></div>'
    controller.render :inline => message, :status => 401, :layout => true, :protocol => 'https'
  end
end