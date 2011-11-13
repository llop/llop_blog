class AdminTagsController < AdminController
  
  # cache stuff
  caches_action :show
  
  # GET /admin/tags/1
  # GET /admin/tags/1/page/1
  def show
    @tag = Tag.find params[:id]
    @posts = Post.search_by_tag_id(params[:id], params[:page])
  end
  
  # POST admin/tags
  def create
    @tag = Tag.new params[:tag] 
    if @tag.save
      redirect_to categories_tags_path, :notice => "The tag was successfully created!"
    else
      @categories = Category.all
      @tags = Tag.all
      @category = Category.new
      render 'admin_categories_tags/categories_tags'
    end
  end
  
end
