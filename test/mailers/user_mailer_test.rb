require File.expand_path("../../test_helper", __FILE__)


class UserMailerTest < ActionMailer::TestCase


  test "account_activation" do
    mail = UserMailer.account_activation
    assert_not_nil mail
  end

end


