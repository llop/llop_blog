class CategoriesController < BlogController
  
  # caches
  caches_action :show
  
  # GET /blog/categories/1
  # GET /blog/categories/1/page/1
  def show 
    @category = Category.find params[:id]
    @posts = Post.page(params[:page]).where('category_id = ?', params[:id]).order('created_at desc')
  end
  
end
