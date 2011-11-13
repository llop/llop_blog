class PostsController < BlogController
  
  # cache
  caches_action :archives, :index
  
  # filters
  before_filter :only => :archives do |controller|
    count = Post.where("extract(year from created_at) = ? and extract(month from created_at) = ?", params[:year], params[:month]).count
    routing_error if count == 0
  end
  
  # GET /blog/search
  def search
    @posts = Post.search(params[:search], params[:page])
  end
  
  # GET /blog/archive/2011/11
  # GET /blog/archive/2011/11/page/1
  def archives
    @posts = Post.page(params[:page]).where("extract(year from created_at) = ? and extract(month from created_at) = ?", params[:year], params[:month])
  end
  
  # GET /blog/posts
  # GET /blog/posts/page/1
  def index
    @posts = Post.page(params[:page]).order('created_at desc')
  end

  # GET /blog/posts/1
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

end
