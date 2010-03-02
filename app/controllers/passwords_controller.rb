class PasswordsController < ApplicationController
  before_filter :require_anonymous
  
  before_filter :find_users
  before_filter :find_user_with_email, :only => [ :create ]
  before_filter :find_user, :only => [ :edit, :update ]
  
  before_filter :new_password, :only => [ :new ]
  before_filter :create_password, :only => [ :create ]
  before_filter :update_user, :only => [ :update ]
    
  # GET /passwords/reset
  def new
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /passwords/:id/reset
  def edit
    respond_to do |format|
      format.html # edit.html
    end
  end

  # POST /passwords
  def create        
    flash[:notice] = t('created')
    
    respond_to do |format|
      format.html { redirect_to new_user_session_url }
    end
  end

  # PUT /passwords/:id
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
    def create_password
      @user.deliver_password_reset_instructions!
    end
    
    def find_user
      unless @user = @users.find_using_perishable_token(params[:id], 1.week)
        flash[:warning] = t('not_found')
        
        redirect_to new_user_session_path
      end
    end
    
    def find_user_with_email
      unless @user = @users.find_by_email(params[:user][:email])
        flash[:warning] = t('not_found')
        
        redirect_to new_password_path
      end
    end
    
    def find_users
      @users = User.scoped(:conditions => { :confirmed => true })
    end
    
    def new_password
      @email = ""
    end
    
    def update_user
      @user.attributes = { :password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation] }
    end
end