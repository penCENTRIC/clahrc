require 'test_helper'

class ReceivedMessageNotifierTest < ActionMailer::TestCase
  test "received_message_notification" do
    @expected.subject = 'ReceivedMessageNotifier#received_message_notification'
    @expected.body    = read_fixture('received_message_notification')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ReceivedMessageNotifier.create_received_message_notification(@expected.date).encoded
  end

end
