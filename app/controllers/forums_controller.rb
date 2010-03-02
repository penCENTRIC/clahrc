class ForumsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_groups
  before_filter :find_group
  
  before_filter :find_forums
  before_filter :find_forum, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :new_forum, :only => [ :new ]
  before_filter :create_forum, :only => [ :create ]
  before_filter :update_forum, :only => [ :update ]
  before_filter :destroy_forum, :only => [ :destroy ]
  
  after_filter :track_forum, :only => [ :create ]
  
  paginate :forums, :name => 'directory', :per_forum => 10, :path => :directory_forums_path, :only => [ :index ]

  # GET /groups/:group_id/forums
  def index
    add_breadcrumb t('index'), group_forums_path(@group)
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /forums/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /forums/new
  def new
    add_breadcrumb t('new'), new_group_forum_path(@group)
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /forums/:id/edit
  def edit
    add_breadcrumb t('edit'), edit_forum_path(@forum)
    
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # POST /forums/create
  def create
    if @forum.save
      flash[:notice] = t('created')

      respond_to do |format|
        format.html { redirect_to forum_path(@forum) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /forums/:id
  def update
    if @forum.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to forum_path(@forum) }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end
  
  # DELETE /forums/:id
  def destroy
    respond_to do |format|
      format.html { redirect_to forums_path }
    end
  end
  
  protected
    def create_forum
      @forum = @forums.new(params[:forum])
    end
    
    def destroy_forum
      @forum.destroy
    end
    
    def destroy_forum_with_authority
      if @forum.can_be_destroyed_by?(current_user)
        destroy_forum_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to forum_path(@forum) }
        end
      end
    end
    
    alias_method_chain :destroy_forum, :authority
    
    def directory_forums_path(directory)
      group_directory_forums_path(@group, directory)
    end
    
    def find_forum
      if forum = @forums.find_by_id(params[:id].to_i)
        found_forum(forum)
      elsif forum = Forum.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to forum.group ? group_forums_path(@group) : groups_path }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to groups_path }
        end
      end
    end
    
    def track_forum
      if @forum.valid?
        ForumActivity.create(:trackable => @forum, :user => current_user, :group => @forum.group, :controller => controller_name, :action => action_name, :access => @forum.access)
      end
    rescue
      nil
    end
    
    def new_forum
      @forum = @forums.new
    end
    
    def update_forum
      @forum.attributes = params[:forum]
    end
    
    def update_forum_with_authority
      if @forum.can_be_edited_by?(current_user)
        update_forum_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to forum_path(@forum) }
        end
      end
    end
    
    alias_method_chain :update_forum, :authority
end
