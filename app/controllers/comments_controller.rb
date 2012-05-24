class CommentsController < BlogController
  
  # caches
  cache_sweeper :comments_sweeper
  
  # POST /comments
  def create
    # Prepare post + comment
    @post = Post.find params[:post_id]
    @comment = Comment.new params[:comment]
    @comment.post = @post
    
    # Dont mail from shit ips
    if (@comment.save)
      AdminMailer.comment_created(@comment, request).deliver
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end
  
end
