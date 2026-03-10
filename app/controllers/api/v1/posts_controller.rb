class Api::V1::PostsController < ApplicationController
  before_action :fetch_user, only: %i[index create update]
  before_action :fetch_post, only: %i[update]

  # GET api/v1/users/:user_id/posts
  # list posts along with user details
  def index
    @posts = @user.posts.includes(:user)
    render json: @posts.as_json(include: :user)
  end

  # POST api/v1/users/:user_id/posts
  def create
    @post = @user.posts.new(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH api/v1/users/:user_id/posts/:id
  def update
    if @post.update(update_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
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
    @user = User.find_by(id: params[:user_id])

    return if @user.present?

    render json: { error: "User not found" }, status: :not_found
  end

  def fetch_post
    @post = Post.find_by(id: params[:id])

    return if @post.present?

    render json: { error: "Post not found" }, status: :not_found
  end
end
