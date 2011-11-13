class ApplicationController < ActionController::Base
  
  # caches
  caches_action :routing_error
  
  # forgery filter
  protect_from_forgery
  
  # rescue!
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::RoutingError, :with => :render_404
  
  def routing_error
    render_404
  end
  
  # Protected methods
protected
  def render_404(exception = nil)
    message = '<div style="padding:60px 20px 60px 20px; font-style:italic;"><span>What the hell are you looking for?</span></div>'
    render :inline => message, :status => 404, :layout => 'blog_error'
  end
  
end
