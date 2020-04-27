require File.expand_path("../../test_helper", __FILE__)
require_relative '../helpers/sign_in_helper'

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  
  def test_login
     # get the login page
     get "/login"
     assert_equal 200, status
  end
end


