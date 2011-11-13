class AdminCommentsController < AdminController
  
  # caches
  cache_sweeper :comments_sweeper
  
  # DELETE /admin/posts/1
  def destroy
    @comment = Comment.find params[:id]
    @post = @comment.post 
    @comment.destroy
    redirect_to edit_post_path(@post.id), :notice => "The post was successfully updated!"
  end
  
end
