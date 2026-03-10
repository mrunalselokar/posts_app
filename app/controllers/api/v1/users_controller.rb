class Api::V1::UsersController < ApplicationController
  before_action :fetch_user, only: [:update]
 
  # GET api/v1/users
  def index
    @users = User.all
    if @users.empty?
      render json: {error: "No users found"}, status: 404
      return
    end
    render json: @users
  end

  # POST api/v1/users 
  # create user along with respective posts
  def create
    @user = User.new(user_params)
    @user.posts.build(posts_attributes) if params[:posts_attributes].present?
    if @user.save
       @posts = @user.posts.includes(:user)
      render json: @user.as_json(include: :posts), status: 201
    else
      render json: @user.errors, status: 422
    end
  end

  # PATCH api/v1/users/:id
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name)
  end

  def posts_attributes
    #  undefined method `permit' for [#<ActionController::Parameters {\"title\"=>\"second\"} permitted: false>]:Array>", so we need to permit each post attributes separately
    params[:posts_attributes].map do |post_attr|
      post_attr.permit(:title, :isActive)
    end
  end

  def fetch_user
    @user = User.find(params[:id])
    if(!@user)
      render json: {error: "User not found"}, status: 404
      return
    end
  end
end
