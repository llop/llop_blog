class BlogController < ApplicationController
  
  # rescue!
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::RoutingError, :with => :render_404
  
  # Filters
  before_filter :load_categories
  before_filter :load_tag_cloud
  before_filter :load_archives
  
  def routing_error
    render_404
  end
  
  # Protected methods
protected
  def render_404(exception = nil)
    message = '<div style="padding:60px 20px 60px 20px; font-style:italic;"><span>What the hell are you looking for?</span></div>'
    render :inline => message, :status => 404, :layout => true
  end
  
  def load_categories
    @categories = Category.order "name asc"
  end
  
  def load_tag_cloud
    query = "select count(id) as count, t.id as id, t.name as name " +
            "from posts_tags as pt, tags as t where pt.tag_id = t.id " +
            "group by id, t.id, t.name order by count desc limit 20"
    @tags_data = Tag.find_by_sql query
    unless @tags_data.empty?
      least = @tags_data.last[:count].to_i
      @posts_count = @tags_data.first[:count].to_i - least
      @tags_data.each { |tag_data| tag_data[:count] = tag_data[:count].to_i - least }
      @tags_data.shuffle!
    end
  end
  
  def load_archives
    query = "select distinct extract(year from p.created_at) as year, extract(month from p.created_at) as month, count (p.created_at) as count " + 
            "from posts as p group by p.created_at order by year desc, month desc"
    @archives = Tag.find_by_sql query
  end
  
end
