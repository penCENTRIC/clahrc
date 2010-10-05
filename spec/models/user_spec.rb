require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "processing notifications" do
    before(:each) do
      @new_notification = Notification.new
      @new_notification.stubs(:save).returns(true)
      
      @user = User.new
      @notification_proxy = stub_everything('notifications', :find_or_initialize_by_activity_id => @new_notification)
      @preferences_proxy = stub_everything('notification preferences')
      
      @user.stubs(:notifications).returns(@notification_proxy)
      @user.stubs(:notification_preferences).returns(@preferences_proxy)
      
      @activity = stub('comment activity', :id => 1)
      @details = { :event => 'new content in group', :status => 'posted', :activity => self }
    end
    
    it "looks to see if a notification has been sent for this activity" do
      @notification_proxy.expects(:find_or_initialize_by_activity_id).returns(@new_notification)
      @user.process_notification(@details)
    end
    
    it "looks for a contextual preference if appropriate" do
      @preferences_proxy.expects(:find_by_context).returns(nil)
      @user.process_notification(@details, Group.new)
    end
    
    it "saves the resulting notification" do
      @new_notification.expects(:save).returns(true)
      @user.process_notification(@details)
    end
  end
end
