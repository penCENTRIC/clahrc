class PagesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member, :only => [ :index, :new, :create, :block ]
  
  before_filter :find_groups
  before_filter :find_group, :only => [ :index, :new, :create, :block ]
  
  before_filter :find_pages
  before_filter :find_page, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :new_page, :only => [ :new ]
  before_filter :create_page, :only => [ :create ]
  before_filter :update_page, :only => [ :update ]
  before_filter :destroy_page, :only => [ :destroy ]
  
  after_filter :track_page, :only => [ :create ]  
  
  paginate :pages, :name => 'directory', :per_page => 10, :path => :directory_pages_path, :only => [ :index ]

  # GET /pages
  def index
    add_breadcrumb t('index'), @template.path_for_pages(@group || @user || current_user)
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /pages/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /pages/new
  def new
    add_breadcrumb t('index'), @template.path_for_pages(@group || current_user)
    add_breadcrumb t('new'), @template.path_for_new_page(@group || current_user)
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /pages/:id/edit
  def edit
    add_breadcrumb t('edit'), @template.path_for_edit_page(@page)
    
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # POST /pages/create
  def create
    if @page.save
      flash[:notice] = t('created')

      if @group
        current_user.pages << @page
      end     
    
      respond_to do |format|
        format.html { redirect_to @template.path_for_page(@page) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /pages/:id
  def update
    if @page.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to @template.path_for_page(@page) }
      end
    else
      respond_to do |format|
        format.html { render :show }
      end
    end
  end
  
  # DELETE /pages/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to @template.path_for_pages(@group || current_user) }
    end
  end
  
  # GET /pages/block
  def block
    respond_to do |format|
      format.html { render :block, :layout => false }
    end
  end
  
  # PUT /pages/sort
  def sort
    Page.order(params[:page])
    render :nothing => true
  end
  
  protected
    def create_page
      new_asset_attributes = if params[:page].has_key?(:new_asset_attributes)
         params[:page].delete(:new_asset_attributes)
      else
        nil
      end
      
      # Create page first
      @page = @pages.new(params[:page])
      
      @page.new_asset_attributes = new_asset_attributes unless new_asset_attributes.nil?
    end
    
    def destroy_page
      @page.destroy
    end

    def destroy_page_with_authority
      if @page.can_be_destroyed_by?(current_user)
        destroy_page_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to page_path(@page) }
        end
      end
    end
    
    alias_method_chain :destroy_page, :authority
      
    def find_page
      if page = @pages.find_by_id(params[:id].to_i)
        found_page(page)
      elsif page = Page.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to @template.path_for_pages(page.group || page.user || current_user) }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to @template.path_for_pages(@group || @user || current_user) }
        end
      end
    end
    
    def new_page
      @page = @pages.new
    end
    
    def track_page
      if @page.valid?
        PageActivity.create(:trackable => @page, :user => current_user, :group => @page.group, :controller => controller_name, :action => action_name, :access => @page.access)
      end
    rescue
      nil
    end
    
    def update_page
      new_asset_attributes = if params[:page].has_key?(:new_asset_attributes)
        params[:page].delete(:new_asset_attributes)
      else
        nil
      end
      
      existing_asset_attributes = if params[:page].has_key?(:existing_asset_attributes)
        params[:page].delete(:existing_asset_attributes)
      else
        {}
      end
      
      # Update page first
      @page.attributes = params[:page]
      
      @page.new_asset_attributes = new_asset_attributes unless new_asset_attributes.nil?
      @page.existing_asset_attributes = existing_asset_attributes
    end
    
    def update_page_with_authority
      if @page.can_be_edited_by?(current_user)
        update_page_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to page_path(@page) }
        end
      end
    end
    
    alias_method_chain :update_page, :authority
    
  private
    def directory_pages_path(directory)
      case
      when @user
        member_directory_pages_path(@user, directory)
      when @group
        group_directory_pages_path(@group, directory)
      else
        my_directory_pages_path(directory)
      end
    end
end