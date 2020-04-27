require File.expand_path("../../test_helper", __FILE__)
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
    @user.update(user_name: 'hellohello', password: 'secret', password_confirmation: 'secret')
    assert @user.user_name == 'hellohello'
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      @user.destroy
    end
  end
end
