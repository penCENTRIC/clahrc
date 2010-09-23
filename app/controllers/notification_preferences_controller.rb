class NotificationPreferencesController < ApplicationController
  before_filter :require_authentic
  
  def index
    add_breadcrumb t('notification_preferences')
    @preferences = NotificationPreference.build_or_retrieve_top_level_for_user(current_user)
    @group_preferences = current_user.groups.collect do |group|
      current_user.notification_preferences.for_context(group).first || current_user.notification_preferences.build(:context => group)
    end
      
  end
  
  def create
    @preference = current_user.notification_preferences.build(params[:notification_preferences])
    if @preference.save
      flash[:notice] = 'Preference updated'
    else
      flash[:notice] = 'Couldn\'t update preference'
    end
    redirect_to my_notification_preferences_path
  end
  
  def update
    @preference = current_user.notification_preferences.find(params[:id])
    
    if @preference.update_attributes(params[:notification_preferences])
      flash[:notice] = 'Preference updated'
    else
      flash[:notice] = 'Couldn\'t update preference'
    end

    redirect_to my_notification_preferences_path
  end
end
