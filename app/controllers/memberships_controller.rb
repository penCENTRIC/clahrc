class MembershipsController < ApplicationController
  before_filter :require_authentic

  before_filter :find_members
  before_filter :find_member

  before_filter :find_groups
  before_filter :find_group

  before_filter :find_memberships, :only => [ :index, :new, :create, :destroy, :promote ]
  before_filter :find_pending_memberships, :only => [ :pending, :accept, :reject ]
  before_filter :find_invited_memberships, :only => [ :accept, :invited, :reject ]
  
  before_filter :find_membership, :only => [ :destroy, :accept, :reject, :promote ]
  
  before_filter :new_membership, :only => [ :new ]
  before_filter :create_membership, :only => [ :create ]
  before_filter :create_invited_membership, :only => [ :invite ]
  
  before_filter :require_moderatorship, :only => [ :destroy, :accept, :promote, :reject ]

  before_filter :destroy_membership, :only => [ :destroy ]
  
  before_filter :accept_membership, :only => [ :accept ]
  before_filter :promote_membership, :only => [ :promote ]
  before_filter :reject_membership, :only => [ :reject ]
  
  after_filter :track_membership, :only => [ :create ]
  
  paginate :memberships, :name => 'directory', :per_page => 10, :path => :directory_memberships_path, :only => [ :index, :pending ]
  paginate :invited_memberships, :name => 'directory', :per_page => 10, :path => :directory_memberships_path, :only => [ :invited ]

  # GET /groups/:group_id/members
  # GET /members/:member_id/groups
  def index
    if @group
      add_breadcrumb 'Members', memberships_path
    else
      add_breadcrumb 'Groups', memberships_path
    end
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  def new
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # POST /groups/:group_id/members
  def create
    if @membership.save
      flash[:notice] = t('created')
    
      respond_to do |format|
        format.html { redirect_to group_path(@group) }
      end
    else
      flash[:notice] = t('not_created')

      respond_to do |format|
        format.html { redirect_to group_path(@group) }
      end
    end
  end
  
  # DELETE /groups/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to my_memberships_path }
    end
  end
  
  # GET /groups/:group_id/memberships/pending
  def pending
    add_breadcrumb t('index'), memberships_path
    add_breadcrumb t('pending'), pending_memberships_path
    
    respond_to do |format|
      format.html # pending.html
    end
  end    
      
  # GET /groups/invited
  def invited
    add_breadcrumb t('index'), memberships_path
    add_breadcrumb t('invited'), invited_my_memberships_path
    
    respond_to do |format|
      format.html # invited.html
    end
  end    
      
  # PUT /groups/:group_id/memberships/:id/accept
  def accept
    flash[:notice] = t('accepted')
    
    respond_to do |format|
      format.html { redirect_to @invited_membership ? group_path(@invited_membership.group) : pending_memberships_path }
    end
  end
  
  # PUT /groups/:group_id/memberships/:id/promote
  def promote
    flash[:notice] = t('promoted')
    
    respond_to do |format|
     format.html { redirect_to group_memberships_path(@group) }
   end
 end
 
  # PUT /groups/:group_id/memberships/:id/reject
  def reject
    flash[:notice] = t('rejected')
    
    respond_to do |format|
      format.html { redirect_to pending_memberships_path }
    end
  end
  
  def invite
    flash[:notice] = t('invited')
    
    respond_to do |format|
      format.html { redirect_to group_memberships_path(@group) }
    end
  end
    
  protected
    def accept_membership
      @membership.accept!
    end  
    
    def create_membership
      @membership = @memberships.find_or_create_by_user_id(current_user.id)
    end

    def create_invited_membership
      if params[:membership][:user_id]
        params[:membership][:user_id].split(',').uniq.each do |user_id|
          @group.invited_memberships.find_or_create_by_user_id(user_id, :confirmed => false)
        end
      end
    end
      
    def destroy_membership
      @membership.destroy
    end
    
    def find_membership
      if @membership = @memberships.find_by_id(params[:id])
        # do nothing
      elsif @membership = @invited_memberships.find_by_id(params[:id])
        @invited_membership = @membership
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to my_memberships_path }
        end
      end
    end

    def find_invited_memberships
      @invited_memberships = current_user.invited_memberships
    end
        
    def find_memberships
      @memberships = case
      when @user
        if current_user.friends.include?(@user) || current_user.id == @user.id
          if current_user.group_ids.blank?
            @user.memberships.scoped(:include => :relatable, :conditions => { :groups => { :hidden => false } }, :order => '`groups`.`name` ASC')
          else
            @user.memberships.scoped(:include => :relatable, :conditions => [ %{`groups`.`hidden` = :false OR `groups`.`id` IN (:group_ids)}, { :false => false, :group_ids => current_user.group_ids } ], :order => '`groups`.`name` ASC')
          end
        else
          if current_user.group_ids.blank?
            @user.memberships.scoped(:include => :relatable, :conditions => { :groups => { :private => false, :hidden => false } }, :order => '`groups`.`name` ASC')
          else
            @user.memberships.scoped(:include => :relatable, :conditions => [ %{(`groups`.`private` = :false AND `groups`.`hidden` = :false) OR `groups`.`id` IN (:group_ids)}, { :false => false, :group_ids => current_user.group_ids } ], :order => '`groups`.`name` ASC')
          end
        end
      when @group
        @group.memberships.scoped(:include => { :user => :profile }, :order => '`profiles`.`last_name` ASC, `profiles`.`first_name` ASC')
      else
        current_user.memberships.scoped(:include => :relatable, :order => '`groups`.`name` ASC')
      end
    end

    def find_pending_memberships
      @memberships = @group.pending_memberships
    end
    
    def track_membership
      if @membership.valid?
        MembershipActivity.create(:trackable => @membership, :user => current_user, :group => @membership.group, :controller => controller_name, :action => action_name, :access => @membership.group.access)
      end
    rescue
      nil
    end

    def promote_membership
      @membership.promote!
    end
    
    def reject_membership
      @membership.reject!
    end

  private
    def directory_memberships_path(directory)
      case
      when @user
        member_directory_memberships_path(@user, directory)
      when @group
        if params[:action] == 'index'
          group_directory_memberships_path(@group, directory)
        elsif params[:action] == 'pending'
          pending_group_directory_memberships_path(@group, directory)
        end
      when action_name == 'invited'
        invited_my_directory_memberships_path(directory)
      else
        my_directory_memberships_path(directory)
      end
    end
        
    def memberships_path
      case
      when @user
        member_memberships_path(@user)
      when @group
        group_memberships_path(@group)
      else
        my_memberships_path
      end
    end

    def pending_memberships_path
      case
      when @group
        pending_group_memberships_path(@group)
      end
    end
    
    def require_moderatorship
      if @group.moderators.include?(current_user)
        # do nothing
      elsif action_name == 'accept' && @membership.is_a?(InvitedMembership) && @membership.user == current_user
        # do nothing
      elsif action_name == 'reject' && @membership.is_a?(InvitedMembership) && @membership.user == current_user
        # do nothing
      else
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to group_memberships_path(@group) }
        end
      end
    end
    
    def new_membership
      @membership = @memberships.build
    end
end
