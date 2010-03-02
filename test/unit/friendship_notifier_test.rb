require 'test_helper'

class FriendshipNotifierTest < ActionMailer::TestCase
  test "friendship_confirmation" do
    @expected.subject = 'FriendshipNotifier#friendship_confirmation'
    @expected.body    = read_fixture('friendship_confirmation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, FriendshipNotifier.create_friendship_confirmation(@expected.date).encoded
  end

  test "friendship_request" do
    @expected.subject = 'FriendshipNotifier#friendship_request'
    @expected.body    = read_fixture('friendship_request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, FriendshipNotifier.create_friendship_request(@expected.date).encoded
  end

end
