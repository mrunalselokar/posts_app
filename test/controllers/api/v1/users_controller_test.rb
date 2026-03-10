require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    User.destroy_all
    Post.destroy_all
  end

  test "index returns not_found when no users" do
    get api_v1_users_url, as: :json
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "No users found", json["error"]
  end

  test "index returns users list" do
    user = User.create!(email: "user1@test.com", full_name: "User One")

    get api_v1_users_url, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json.size
    assert_equal user.email, json.first["email"]
    assert_equal user.full_name, json.first["full_name"]
  end

  test "create creates user with posts_attributes" do
    payload = {
      user: {
        email: "user2@test.com",
        full_name: "User Two"
      },
      posts_attributes: [
        { title: "Post A", isActive: true },
        { title: "Post B", isActive: false }
      ]
    }

    assert_difference("User.count", 1) do
      assert_difference("Post.count", 2) do
        post api_v1_users_url, params: payload, as: :json
      end
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "user2@test.com", json["email"]
    assert_equal 2, json["posts"].size
  end

  test "create returns unprocessable_entity when email missing" do
    payload = { user: { full_name: "No Email" } }

    post api_v1_users_url, params: payload, as: :json
    assert_response :unprocessable_entity

    json = JSON.parse(response.body)
    assert json.key?("email")
  end

  test "update updates user attributes" do
    user = User.create!(email: "user3@test.com", full_name: "User Three")

    patch api_v1_user_url(user), params: { user: { full_name: "Updated Name" } }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Updated Name", json["full_name"]
  end

  test "update returns unprocessable_entity with invalid data" do
    user = User.create!(email: "user4@test.com", full_name: "User Four")

    patch api_v1_user_url(user), params: { user: { email: "" } }, as: :json
    assert_response :unprocessable_entity

    json = JSON.parse(response.body)
    assert json.key?("email")
  end

  test "update returns not_found for missing user" do
    patch api_v1_user_url(id: 0), params: { user: { full_name: "No User" } }, as: :json
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "User not found", json["error"]
  end
end
