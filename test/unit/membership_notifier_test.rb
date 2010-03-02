require 'test_helper'

class MembershipNotifierTest < ActionMailer::TestCase
  test "membership_confirmation" do
    @expected.subject = 'MembershipNotifier#membership_confirmation'
    @expected.body    = read_fixture('membership_confirmation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, MembershipNotifier.create_membership_confirmation(@expected.date).encoded
  end

  test "membership_request" do
    @expected.subject = 'MembershipNotifier#membership_request'
    @expected.body    = read_fixture('membership_request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, MembershipNotifier.create_membership_request(@expected.date).encoded
  end

end
