class TagsController < BlogController
  
  # GET /blog/tags/1
  def show 
    @tag = Tag.find params[:id]
    @posts = Post.search_by_tag_id(params[:id], params[:page])
  end
  
end