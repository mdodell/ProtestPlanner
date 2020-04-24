require 'test_helper'
require_relative '../helpers/sign_in_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  setup do
    @user = users(:one)
  end

  test "should get index" do
    sign_in_as(users(:one), 'secret')
    get users_url
    assert_response :success
  end

  test "should get new" do

    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: @user.email, password: 'secret', password_confirmation: 'secret' } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    sign_in_as(users(:one), 'secret')
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(users(:one), 'secret')
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, password: 'secret', password_confirmation: 'secret' } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
