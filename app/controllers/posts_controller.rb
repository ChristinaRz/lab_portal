class PostsController < ApplicationController
  #υποχρεωτικό login για όλες τις ενέργειες
  before_action :authenticate_user!
  #post για show/edit/update/destroy
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_post!, only: [:edit, :update, :destroy]

  # GET /posts
  # Λίστα posts (νεότερα πρώτα)
  #αναζήτηση και φιλτράρισμα
  def index
    @posts = Post.all.order(created_at: :desc)
    @categories = Category.all

    #φιλτράρισμα με βάση αναζήτηση
    if params[:search].present?
      @posts = @posts.search(params[:search])
    end

    #φιλτράρισμα με βάση κατηγορία
    if params[:category_id].present?
      @posts = @posts.by_category(params[:category_id])
    end
  end

  # GET /posts/:id
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
    @categories = Category.all
  end

  # POST /posts
  # Δημιουργία νέου post
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post created successfully.'
    else
      @categories = Category.all
      flash.now[:alert] = 'Post creation failed. Check the fields.'
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/edit
  def edit
    @categories = Category.all
  end

  # PATCH/PUT /posts/:id 
  # Ενημέρωση post
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post updated successfully.'
    else
      @categories = Category.all
      flash.now[:alert] = 'Post update failed. Check the fields.'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id 
  # Διαγραφή post
  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post deleted successfully.'
  end

  private

  def set_post
    #αναζήτηση post με βάση το id από το URL
    @post = Post.find(params[:id])
  end

# ελέγχει ότι το post ανήκει στον current_user πριν από edit/update/destroy
  def authorize_post!
    unless @post.user == current_user
      redirect_to posts_path, alert: 'Not allowed.'
    end
  end


  def post_params
  #επιτρέπονται title, body και category_id
  params.require(:post).permit(:title, :body, :category_id)
end
end