class BlogController < ApplicationController
  
  # Filters
  before_filter :filter_shit_ips
  before_filter :load_categories
  before_filter :load_tag_cloud
  before_filter :load_archives
  
  # Protected methods
protected
  
  def filter_shit_ips
    # Quick deal with shit ips
    shit_ips = [ "217.172.180.18", "62.75.181.210" ]
    if shit_ips.include?(request.remote_ip)
      render :inline => "<html><head><meta http-equiv=\"Refresh\" content=\"0; url=http://www.sandnes-sykleklubb.no\" /></head><body></body></html>", :status => 200
    end
  end
  
  def load_categories
    @categories = Category.order_by_name_asc_cached
  end
  
  def load_tag_cloud
    @tags_data = Tag.cloud_data_cached
    @posts_count = @tags_data.empty? ? 0 : @tags_data.first[:count]
  end
  
  def load_archives
    @archives = Post.archives_cached
  end
  
end
