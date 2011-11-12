class AdminCategoriesTagsController < AdminController
  
  def categories_tags
    @categories = Category.all
    @tags = Tag.all
    @category = Category.new
    @tag = Tag.new
  end
  
end
