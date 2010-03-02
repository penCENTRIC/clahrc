class ModeratorshipsController < ApplicationController
  before_filter :require_authentic

  before_filter :find_groups
  before_filter :find_group

  before_filter :find_moderatorships
  before_filter :find_moderatorship, :only => [ :promote ]
  
  before_filter :require_ownership, :only => [ :promote ]

  before_filter :promote_moderatorship, :only => [ :promote ]
    
  paginate :moderatorships, :name => 'directory', :per_page => 10, :path => :directory_moderatorships_path, :only => [ :index ]
    
  layout 'memberships'
  
  # GET /groups/:group_id/moderators
  def index
    add_breadcrumb t('index'), group_moderatorships_path(@group)
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # PUT /groups/:group_id/moderators/:id/promote
  def promote
    flash[:notice] = t('promoted')
    
    respond_to do |format|
     format.html { redirect_to group_moderatorships_path(@group) }
   end
 end
 
  protected
    def directory_moderatorships_path(directory)
      group_directory_moderatorships_path(@group, directory)
    end

    def find_moderatorship
      unless @moderatorship = @moderatorships.find_by_id(params[:id])
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to group_moderatorships_path(@group) }
        end
      end
    end

    def find_moderatorships
      @moderatorships = @group.moderatorships
    end
    
    def promote_moderatorship
      @moderatorship.promote!
    end
    
    def require_ownership
      unless @group.owners.include? current_user
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to group_moderatorships_path(@group) }
        end
      end
    end
end
