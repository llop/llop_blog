class ApplicationController < ActionController::Base
  
  # caches
  caches_action :routing_error
  
  # forgery filter
  protect_from_forgery
  
  # rescue!
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :exception_handler
  
  def routing_error
    render_404
  end
  
  def exception_handler(exception)
    render_500 exception
  end
  
  # Protected methods
protected
  def render_500(exception)
    begin
      AdminMailer.something_crashed(exception).deliver
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    end
    message = '<img src="<%= asset_path "500.jpg" %>" alt="" width="400" height="400" />'
    render :inline => message, :status => 500, :layout => 'blog_error'
  end
    
  def render_404(exception = nil)
    message = '<img src="<%= asset_path "404.jpg" %>" alt="" width="400" height="400" />'
    render :inline => message, :status => 404, :layout => 'blog_error'
  end
  
end
