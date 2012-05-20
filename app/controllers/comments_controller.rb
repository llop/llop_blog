class CommentsController < BlogController
  
  # caches
  cache_sweeper :comments_sweeper
  
  # POST /comments
  def create
    # Quick deal with shit ips
    shit_ips = [ "188.138.84.93", "62.75.181.210" ]
    is_shit_ip = shit_ips.include?(request.remote_ip)
    
    # Prepare post + comment
    @post = Post.find params[:post_id]
    @comment = Comment.new params[:comment]
    @comment.post = @post
    
    # Dont mail from shit ips
    if (is_shit_ip || @comment.save)
      AdminMailer.comment_created(@comment, request).deliver unless is_shit_ip
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end
  
end
