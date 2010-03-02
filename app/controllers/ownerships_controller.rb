class OwnershipsController < ApplicationController
  before_filter :require_authentic

  before_filter :find_groups
  before_filter :find_group

  before_filter :find_ownerships

  paginate :ownerships, :name => 'directory', :per_page => 10, :path => :directory_ownerships_path, :only => [ :index ]

  layout 'memberships'
  
  # GET /groups/:group_id/owners
  def index
    add_breadcrumb t('index'), group_ownerships_path(@group)
    
    respond_to do |format|
      format.html # index.html
    end
  end
    
  protected
    def directory_ownerships_path(directory)
      group_directory_ownerships_path(@group, directory)
    end
    
    def find_ownerships
      @ownerships = @group.ownerships
    end
end
