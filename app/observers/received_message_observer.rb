class ReceivedMessageObserver < ActiveRecord::Observer
  def after_create(received_message)
    unless received_message.nil?
      begin
        ReceivedMessageActivity.create(:trackable => received_message, :user => received_message.user, :access => :hidden)
      rescue Exception => e
        Rails.logger.info(e.inspect)
      end
    end
  end
end
