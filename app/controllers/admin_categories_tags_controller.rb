class AdminCategoriesTagsController < AdminController
  
  # GET /admin/categories_tags
  def categories_tags
    @categories = Category.all
    @tags = Tag.all
    @category = Category.new
    @tag = Tag.new
  end
  
end
