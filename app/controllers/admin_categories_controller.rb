class AdminCategoriesController < AdminController
  
  # cache stuff
  caches_action :show
  
  # GET /admin/categories/1
  # GET /admin/categories/1/page/1
  def show
    @category = Category.find params[:id]
    @posts = Post.page(params[:page]).where('category_id = ?', params[:id]).order('created_at desc')
  end
  
  # POST admin/categories
  def create
    @category = Category.new params[:category] 
    if @category.save
      redirect_to categories_tags_path, :notice => "The category was successfully created!"
    else
      @categories = Category.all
      @tags = Tag.all
      @tag = Tag.new
      render 'admin_categories_tags/categories_tags'
    end
  end
  
end
