class BlogController < ApplicationController
  
  # Filters
  before_filter :load_categories
  before_filter :load_tag_cloud
  before_filter :load_archives
  
  # Protected methods
protected
  
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
