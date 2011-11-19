ActionController::HttpAuthentication::Basic.module_eval do
  def authentication_request(controller, realm)
    controller.headers["WWW-Authenticate"] = %(Basic realm="#{realm.gsub(/"/, "")}")
    message = '<img src="<%= asset_path "401.jpg" %>" alt="" width="400" height="400" />'
    controller.render :inline => message, :status => 401, :layout => "blog_error"
  end
end