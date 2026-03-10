class Api::V1::PostsController < ApplicationController
  before_action :fetch_user, only: [:index, :create, :update]
  before_action :fetch_post, only: [:update]

  # GET api/v1/users/:user_id/posts
  # list Posts along with user details
  def index
    @posts = @user.posts.includes(:user)
    render json: @posts.as_json(include: :user)
  end

  # POST api/v1/users/:user_id/posts
  def create
    @post = @user.posts.new(post_params)
    if @post.save
      render json: @post, status: 201
    else
      render json: @post.errors, status: 422
    end
  end


  # PATCH api/v1/users/:user_id/posts/:id
  def update
    if @post.update(update_params)
      render json: @post
    else
      render json: @post.errors, status: 422
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :isActive, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :isActive)
  end

  def fetch_user
    @user = User.find(params[:user_id])
    if(!@user)
      render json: {error: "User not found"}, status: 404
      return
    end
  end

  def fetch_post
    @post = Post.find(params[:id])
    if(!@post)
      render json: {error: "Post not found"}, status: 404
      return
    end
  end
end
