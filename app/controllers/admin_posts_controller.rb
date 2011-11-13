class AdminPostsController < AdminController
  
  # cache
  caches_action :index
  cache_sweeper :posts_sweeper
  
  # GET /admin/search
  def search
    @posts = Post.search(params[:search], params[:page])
  end
 
  # GET /admin/posts
  # GET /admin/posts/page/1
  def index
    @posts = Post.page(params[:page]).order('created_at desc')
  end
  
  # GET admin/posts/new
  def new
    @post = Post.new
    @categories = Category.all
    @tags = Tag.all
  end

  # GET admin/posts/1/edit
  def edit
    @post = Post.find params[:id]
    @categories = Category.all
    @tags = Tag.all
  end

  # PUT admin/posts/1
  def update
    @post = Post.find params[:id]
    if @post.update_attributes params[:post]
      redirect_to edit_post_path(@post.id), :notice => "The post was successfully updated!"
    else
      @categories = Category.all
      @tags = Tag.all
      render :edit
    end
  end

  # POST admin/posts
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to edit_post_path(@post.id), :notice => "The post was successfully created!"
    else
      @categories = Category.all
      @tags = Tag.all
      render :new
    end
  end

end
