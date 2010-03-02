class ActivitiesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member, :only => [ :index, :new, :create ]
  
  before_filter :find_groups
  before_filter :find_group, :only => [ :index, :new, :create ]
  
  before_filter :find_activities

  paginate :activities, :name => 'directory', :per_page => 25, :path => :directory_activities_path, :only => [ :index ]
    
  # GET /activities
  def index
    add_breadcrumb t('index'), @template.path_for_activities(@group || @user || current_user)
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  private
    def directory_activities_path(directory)
      case
      when @user
        member_directory_activities_path(directory, @user)
      when @group
        group_directory_activities_path(directory, @group)
      else
        my_directory_activities_path(directory)
      end
    end
end
