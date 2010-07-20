class UsersController < ApplicationController
  before_filter :require_anonymous
  
  before_filter :find_users
  before_filter :find_user, :only => [ :edit, :update ]
  
  before_filter :new_user, :only => [ :new ]
  before_filter :create_user, :only => [ :create ]
  before_filter :update_user, :only => [ :update ]
    
  # GET /users/new
  def new
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /users/:id/activate
  def edit
    respond_to do |format|
      format.html # edit.html
    end
  end

  # POST /users
  def create
    if @user.save_without_session_maintenance
      flash[:notice] = t('created')
      
      @user.deliver_activation_instructions!
      
      respond_to do |format|
        format.html # create.html
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  # PUT /users/:id
  def update
    if @user.save
      flash[:notice] = t('updated')

      @user.confirm!
      
      respond_to do |format|
        format.html { redirect_to my_account_path }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end
  
  protected
    def create_user
      @user = @users.new(params[:user])
    end
    
    def find_user
      unless @user = @users.find_using_perishable_token(params[:id], 1.week)
        flash[:warning] = t('not_found')
        
        redirect_to new_session_path
      end
    end    
    
    def find_users
      @users = User.scoped(:conditions => { :confirmed => false })
    end
    
    def new_user
      @user = @users.new
    end
    
    def update_user
      @user.attributes = params[:user]
    end
end