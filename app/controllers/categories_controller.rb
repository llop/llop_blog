class CategoriesController < BlogController
  
  # GET /blog/categories/1
  def show 
    @category = Category.find params[:id]
    @posts = Post.page(params[:page]).where('category_id = ?', params[:id]).order('created_at desc')
  end
  
end
