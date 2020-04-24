require 'test_helper'
require_relative '../helpers/sign_in_helper'

class MarkersControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  fixtures :users

  setup do
    sign_in_as(users(:one), 'secret')
  end


end
