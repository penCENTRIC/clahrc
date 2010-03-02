class AssetsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member, :only => [ :index, :new, :create, :block ]
  
  before_filter :find_groups
  before_filter :find_group, :only => [ :index, :new, :create, :block ]
  
  before_filter :find_assets
  before_filter :find_asset, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :new_asset, :only => [ :new ]
  before_filter :create_asset, :only => [ :create ]
  before_filter :update_asset, :only => [ :update ]
  before_filter :destroy_asset, :only => [ :destroy ]
  
  paginate :assets, :name => 'directory', :per_page => 10, :path => :directory_assets_path, :only => [ :index ]

  # GET /assets
  def index
    add_breadcrumb t('index'), @template.path_for_assets(@group || @user || current_user)
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /assets/:id
  def show
    send_file @asset.data.path, :filename => @asset.name, :type => @asset.content_type, :disposition => 'attachment'
  end

  # GET /assets/new
  def new
    add_breadcrumb t('index'), @template.path_for_assets(@group || current_user)
    add_breadcrumb t('new'), @template.path_for_new_asset(@group || current_user)
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # POST /assets/create
  def create
    if @asset.save
      flash[:notice] = t('created')

      if @group
        current_user.assets << @asset
      end     
    
      respond_to do |format|
        format.html { redirect_to @template.path_for_assets(@group || @user || current_user) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /assets/:id
  def update
    changes = @asset.changes
    
    if @asset.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to @template.path_for_assets(@group || @user || current_user) }
      end
    else
      respond_to do |format|
        format.html { render :show }
      end
    end
  end
  
  # DELETE /assets/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to @template.path_for_assets(@group || current_user) }
    end
  end
  
  # GET /assets/block
  def block
    respond_to do |format|
      format.html { render :block, :layout => false }
    end
  end
  
  protected
    def create_asset
      @asset = @assets.new(params[:asset])
    end
    
    def destroy_asset
      @asset.destroy
    end
      
    def find_asset
      if asset = @assets.find_by_id(params[:id].to_i)
        found_asset(asset)
      elsif asset = Asset.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to @template.path_for_assets(asset.group || asset.user || current_user) }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to @template.path_for_assets(@group || @user || current_user) }
        end
      end
    end
    
    def new_asset
      @asset = @assets.new
    end
    
    def update_asset
      @asset.attributes = params[:asset]
    end
    
  private
    def directory_assets_path(directory)
      case
      when @user
        member_directory_assets_path(@user, directory)
      when @group
        group_directory_assets_path(@group, directory)
      else
        my_directory_assets_path(directory)
      end
    end
end