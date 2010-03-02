class GroupsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member
  
  before_filter :find_groups
  before_filter :find_group, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :require_ownership, :only => [ :destroy ]
  before_filter :require_moderatorship, :only => [ :edit, :update ]
  
  before_filter :new_group, :only => [ :new ]
  before_filter :create_group, :only => [ :create ]
  before_filter :update_group, :only => [ :update ]
  before_filter :destroy_group, :only => [ :destroy ]
  
  after_filter :track_group, :only => [ :create ]
  
  paginate :groups, :name => 'directory', :per_page => 10, :path => :directory_groups_path, :only => [ :index ]
   
  # GET /groups
  def index
    add_breadcrumb t('index'), groups_path

    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /groups/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /groups/new
  def new
    add_breadcrumb t('index'), groups_path
    add_breadcrumb t('new'), new_group_path
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /groups/:id/edit
  def edit
    add_breadcrumb t('edit'), edit_group_path(@group)
    
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # POST /groups/create
  def create
    if @group.save
      flash[:notice] = t('created')

      @group.ownerships << Ownership.new(:user => current_user, :confirmed => true)
      
      respond_to do |format|
        format.html { redirect_to group_path(@group) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /groups/:id
  def update
    if @group.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to group_path(@group) }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end
  
  # DELETE /groups/:id
  def destroy
    respond_to do |format|
      format.html { redirect_to groups_path }
    end
  end
  
  protected
    def create_group
      @group = Group.new(params[:group])
    end
    
    def destroy_group
      @group.destroy
    end
    
    def find_group
      if group = @groups.find_by_id(params[:id].to_i)
        found_group(group)
      elsif group = Group.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to groups_path }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to groups_path }
        end
      end
    end
    
    def find_groups_with_query
      find_groups_without_query
      
      if @query = params[:q]
        @groups = @groups.search(@query)
      end
    end
    
    alias_method_chain :find_groups, :query
    
    def new_group
      @group = Group.new
    end
    
    def update_group
      @group.attributes = params[:group]
    end
    
    def require_moderatorship
      unless @group.moderators.include? current_user
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to group_path(@group) }
        end
      end
    end
    
    def require_ownership
      unless @group.owners.include? current_user
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to group_path(@group) }
        end
      end
    end
    
    def track_group
      if @group.valid?
        GroupActivity.create(:trackable => @group, :user => current_user, :group => @group, :controller => controller_name, :action => action_name)
      end
    rescue
      nil
    end
end
