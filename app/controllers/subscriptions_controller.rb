class SubscriptionsController < ApplicationController
  before_filter :require_authentic
  before_filter :load_topic

  def create
    @subscription = @topic.subscriptions.build(:user => current_user)
    flash[:notice] = @subscription.save ? 'Subscription created' : 'Failed to create subscription'
    redirect_to :back
  end
  
  def destroy
    @subscription = @topic.subscriptions.for_user(current_user).first
    flash[:notice] = @subscription.destroy ? 'Subscription removed' : 'Failed to remove subscription'
    redirect_to :back
  end
  
  protected
    def load_topic
      @topic ||= Topic.find(params[:topic_id])
    end
end
