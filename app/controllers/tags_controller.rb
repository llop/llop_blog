class TagsController < BlogController
  
  # caches
  caches_action :show
  
  # GET /blog/tags/1
  # GET /blog/tags/1/page/1
  def show 
    @tag = Tag.find params[:id]
    @posts = Post.search_by_tag_id(params[:id], params[:page])
  end
  
end