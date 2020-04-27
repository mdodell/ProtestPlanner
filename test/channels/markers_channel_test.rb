require File.expand_path("../../test_helper", __FILE__)

class MarkersChannelTest < ActionCable::Channel::TestCase
  test "subscribes" do
    subscribe
    assert subscription.confirmed?
  end
end
