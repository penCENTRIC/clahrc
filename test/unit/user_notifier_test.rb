require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "activation_instructions" do
    @expected.subject = 'UserNotifier#activation_instructions'
    @expected.body    = read_fixture('activation_instructions')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserNotifier.create_activation_instructions(@expected.date).encoded
  end

  test "activation_confirmation" do
    @expected.subject = 'UserNotifier#activation_confirmation'
    @expected.body    = read_fixture('activation_confirmation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserNotifier.create_activation_confirmation(@expected.date).encoded
  end

end
