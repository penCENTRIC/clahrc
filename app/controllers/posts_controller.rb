class PostsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member
  
  before_filter :find_posts
  before_filter :find_post, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :new_post, :only => [ :new ]
  before_filter :create_post, :only => [ :create ]
  before_filter :update_post, :only => [ :update ]
  before_filter :destroy_post, :only => [ :destroy ]
  
  after_filter :track_post, :only => [ :create ]
  
  paginate :posts, :name => 'directory', :per_page => 10, :path => :directory_posts_path, :only => [ :index ]
  
  # GET /posts
  def index
    add_breadcrumb t('index'), @user ? member_posts_path(@user) : my_posts_path
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /posts/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /posts/new
  def new
    add_breadcrumb t('index'), my_posts_path
    add_breadcrumb t('new'), new_my_post_path
    
    respond_to do |format|
      format.html # new.html
    end
  end

  # GET /posts/edit
  def edit
    add_breadcrumb t('edit'), edit_my_post_path(@post)
    
    respond_to do |format|
      format.html # edit.html
    end
  end
    
  # POST /posts/create
  def create
    if @post.save
      flash[:notice] = t('created')

      respond_to do |format|
        format.html { redirect_to post_path(@post) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /posts/:id
  def update
    if @post.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to post_path(@post) }
      end
    else
      respond_to do |format|
        format.html { render :show }
      end
    end
  end
  
  # DELETE /posts/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to my_posts_path }
    end
  end
  
  # GET /posts/block
  def block
    respond_to do |format|
      format.html { render :block, :layout => false }
    end
  end
  
  protected
    def create_post
      @post = @posts.new(params[:post])
      
      @post.group = @group
    end
    
    def destroy_post
      @post.destroy
    end

    def destroy_post_with_authority
      if @post.can_be_destroyed_by?(current_user)
        destroy_post_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to post_path(@post) }
        end
      end
    end
    
    alias_method_chain :destroy_post, :authority
      
    def find_post
      if post = @posts.find_by_id(params[:id].to_i)
        found_post(post)
      elsif post = Page.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to post.user ? member_posts_path(post.user) : my_posts_path }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to my_posts_path }
        end        
      end
    end
    
    def new_post
      @post = @posts.new
    end
    
    def track_post
      if @post.valid?
        PostActivity.create(:trackable => @post, :user => current_user, :group => @post.group, :controller => controller_name, :action => action_name, :access => @post.access)
      end
    rescue
      nil
    end
    
    def update_post
      @post.attributes = params[:post]
    end
    
    def update_post_with_authority
      if @post.can_be_edited_by?(current_user)
        update_post_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to post_path(@post) }
        end
      end
    end
    
    alias_method_chain :update_post, :authority
    
    private
      def directory_posts_path(directory)
        case
        when @user
          member_directory_posts_path(@user, directory)
        else
          my_directory_posts_path(directory)
        end
      end
end