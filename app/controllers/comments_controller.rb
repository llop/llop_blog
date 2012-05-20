class CommentsController < BlogController
  
  # caches
  cache_sweeper :comments_sweeper
  
  # POST /comments
  def create
    # Shit ips list
    shit_ips = [ "188.138.84.93", "62.75.181.210" ]
    
    @post = Post.find params[:post_id]
    @comment = Comment.new params[:comment]
    @comment.post = @post
    if (shit_ips.include?(request.remote_ip) || @comment.save)
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end
  
end
