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

  # GET /posts/new
  # GET /posts/new.json
  # def new
  #   @post = Post.new
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @post }
  #   end
  # end

  # GET /posts/1/edit
  # def edit
  #   @post = Post.find(params[:id])
  # end

  # POST /posts
  # POST /posts.json
  # def create
  #   @post = Post.new(params[:post])
  #   respond_to do |format|
  #     if @post.save
  #       format.html { redirect_to @post, notice: 'Post was successfully created.' }
  #       format.json { render json: @post, status: :created, location: @post }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @post.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /posts/1
  # PUT /posts/1.json
  # def update
  #   @post = Post.find(params[:id])
  #   respond_to do |format|
  #     if @post.update_attributes(params[:post])
  #       format.html { redirect_to @post, notice: 'Post was successfully updated.' }
  #       format.json { head :ok }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @post.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /posts/1
  # DELETE /posts/1.json
  # def destroy
  #   @post = Post.find(params[:id])
  #   @post.destroy
  #   respond_to do |format|
  #     format.html { redirect_to posts_url }
  #     format.json { head :ok }
  #   end
  # end
  
end
