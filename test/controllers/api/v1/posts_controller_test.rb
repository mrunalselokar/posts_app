require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    User.destroy_all
    Post.destroy_all
  end

  test "index returns not_found when user missing" do
    get api_v1_user_posts_url(user_id: 0), as: :json
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "User not found", json["error"]
  end

  test "index returns posts with user details" do
    user = User.create!(email: "user10@test.com", full_name: "User Ten")
    post_record = user.posts.create!(title: "Post X", isActive: true)

    get api_v1_user_posts_url(user), as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json.size
    assert_equal post_record.title, json.first["title"]
    assert_equal user.email, json.first["user"]["email"]
  end

  test "create creates post for user" do
    user = User.create!(email: "user11@test.com", full_name: "User Eleven")

    assert_difference("Post.count", 1) do
      post api_v1_user_posts_url(user), params: { post: { title: "New Post", isActive: true } }, as: :json
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "New Post", json["title"]
  end

  test "create returns not_found when user missing" do
    post api_v1_user_posts_url(user_id: 0), params: { post: { title: "No user" } }, as: :json
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "User not found", json["error"]
  end

  test "update updates post attributes" do
    user = User.create!(email: "user12@test.com", full_name: "User Twelve")
    post_record = user.posts.create!(title: "Old title", isActive: false)

    patch api_v1_user_post_url(user, post_record), params: { post: { title: "Updated Title", isActive: true } }, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "Updated Title", json["title"]
    assert_equal true, json["isActive"]
  end

  test "update returns not_found when post missing" do
    user = User.create!(email: "user13@test.com", full_name: "User Thirteen")

    patch api_v1_user_post_url(user, id: 0), params: { post: { title: "No Post" } }, as: :json
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "Post not found", json["error"]
  end
end
