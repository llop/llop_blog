class CommentsController < BlogController
  
  # caches
  cache_sweeper :comments_sweeper
  
  # POST /comments
  def create
    @post = Post.find params[:post_id]
    @comment = Comment.new params[:comment]
    @comment.post = @post
    if @comment.save
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end
  
end
