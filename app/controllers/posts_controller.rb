class PostsController < BlogController
  
  # GET /blog/search
  def search
    @posts = Post.search(params[:search], params[:page])
  end
  
  # GET /blog/archive/2011/11
  def archives
    @posts = Post.page(params[:page]).where("extract(year from created_at) = ? and extract(month from created_at) = ?", params[:year], params[:month])
    routing_error if @posts.empty?
  end
  
  # GET /blog/posts
  def index
    @posts = Post.page(params[:page]).order('created_at desc')
  end

  # GET /blog/posts/1
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

end
