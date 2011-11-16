class BuddhabrotController < ApplicationController
  
  # Filters
  before_filter :validate_article_id, :only => :article
  before_filter :validate_appendix_id, :only => :appendix
  before_filter :validate_applet_id, :only => :applet
  
  # Actions
  def article
    render :partial => ('buddhabrot/article_' + params[:id]), :layout => 'buddhabrot'
  end
  
  def appendix
    render :partial => ('buddhabrot/appendix_' + params[:id]), :layout => 'buddhabrot'
  end
  
  def applet
    render :partial => ('buddhabrot/applet_' + params[:id]), :layout => 'buddhabrot'
  end
  
  def gallery
    render :partial => 'buddhabrot/gallery', :layout => 'buddhabrot'
  end
  
protected
  def validate_article_id
    validate_id(params[:id].to_i, 1, 8)
  end
  def validate_appendix_id
    validate_id(params[:id].to_i, 1, 2)
  end
  def validate_applet_id
    validate_id(params[:id].to_i, 1, 2)
  end
  def validate_id(id, a, b)
    routing_error unless (id >= a and id <= b)
  end
  
end
