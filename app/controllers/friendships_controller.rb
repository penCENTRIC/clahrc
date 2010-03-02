class FriendshipsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member
  
  before_filter :find_friendships, :only => [ :index, :create, :destroy ]
  before_filter :find_pending_friendships, :only => [ :pending, :accept, :reject ]

  before_filter :find_friendship, :only => [ :destroy, :accept, :reject ]

  before_filter :create_friendship, :only => [ :create ]
  before_filter :destroy_friendship, :only => [ :destroy ]
  
  before_filter :accept_friendship, :only => [ :accept ]
  before_filter :reject_friendship, :only => [ :reject ]
  
  paginate :friendships, :name => 'directory', :per_page => 10, :path => :directory_friendships_path, :only => [ :index, :pending ]

  after_filter :track_friendship, :only => [ :create, :accept ]
    
  # GET /friends
  # GET /members/:member_id/friends
  def index
    add_breadcrumb t('index'), friendships_path
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # POST /members/:member_id/friends
  def create
    if @friendship.save
      flash[:notice] = t('created')
    
      respond_to do |format|
        format.html { redirect_to member_path(@user) }
      end
    else
      flash[:notice] = t('not_created')
      
      respond_to do |format|
        format.html { redirect_to member_path(@user) }
      end
    end
  end
  
  # DELETE /friends/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to my_friendships_path }
    end
  end
  
  # GET /friends/pending
  def pending
    add_breadcrumb t('index'), my_friendships_path
    add_breadcrumb t('pending'), pending_my_friendships_path
    
    respond_to do |format|
      format.html # pending.html
    end
  end    
      
  # PUT /friends/:id/accept
  def accept
    flash[:notice] = t('accepted')
    
    respond_to do |format|
      format.html { redirect_to pending_my_friendships_path }
    end
  end
  
  # PUT /friends/:id/reject
  def reject
    flash[:notice] = t('rejected')
    
    respond_to do |format|
      format.html { redirect_to pending_my_friendships_path }
    end
  end
  
  protected
    def accept_friendship
      @friendship.accept!
    end  
    
    def create_friendship
      @friendship = @friendships.find_or_create_by_user_id(current_user.id)
    end

    def destroy_friendship
      @friendship.destroy
    end
    
    def find_friendship
      unless @friendship = @friendships.find_by_id(params[:id])
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to my_friendships_path }
        end
      end
    end
    
    def find_friendships
      @friendships = case
      when @user
        @user.friendships.scoped(:include => { :user => :profile }, :order => '`profiles`.`last_name` ASC, `profiles`.`first_name` ASC')
      else
        current_user.friendships.scoped(:include => { :user => :profile }, :order => '`profiles`.`last_name` ASC, `profiles`.`first_name` ASC')
      end
    end

    def find_pending_friendships
      @friendships = current_user.pending_friendships
    end
    
    def track_friendship
      if @friendship.valid?
        if action_name == 'create'
          FriendshipActivity.create(:trackable => @friendship, :user => @friendship.relatable, :controller => controller_name, :action => action_name, :hidden => true)
        elsif action_name == 'accept'
          if friendship = @friendship.activities.first
            friendship.update_attributes(:hidden => false, :private => true)
          else
            FriendshipActivity.create(:trackable => @friendship, :user => @friendship.relatable, :controller => controller_name, :action => action_name, :private => true)
          end
        
          FriendshipActivity.create(:trackable => @friendship, :user => @friendship.user, :controller => controller_name, :action => action_name, :private => true)
        end
      end
    rescue
      nil
    end
    
    def reject_friendship
      @friendship.reject!
    end
    
  private
    def directory_friendships_path(directory)
      case
      when @user
        member_directory_friendships_path(@user, directory)
      when params[:action] == 'pending'
        pending_my_directory_friendships_path(directory)
      else
        my_directory_friendships_path(directory)
      end
    end
        
    def friendships_path
      case
      when @user
        member_friendships_path(@user)
      else
        my_friendships_path
      end
    end
end
