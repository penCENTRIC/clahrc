class UserSessionsController < ApplicationController
  before_filter :require_anonymous, :only => [ :new, :create ]
  before_filter :require_authentic, :only => [ :destroy ]
  
  before_filter :find_user_session, :only => [ :destroy ]
  before_filter :new_user_session, :only => [ :new ]
  before_filter :create_user_session, :only => [ :create ]
  before_filter :destroy_user_session, :only => [ :destroy ]
   
  # GET /login
  def new
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # POST /login
  def create
    if @user_session.save
      flash[:notice] = t('created')
      
      respond_to do |format|
        format.html { redirect_to_stored_location_or_default my_account_path }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  # DELETE /logout
  # GET /logout
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to new_session_path }
    end
  end
  
  protected
    def create_user_session
      @user_session = UserSession.new(params[:user_session])
    end
    
    def destroy_user_session
      @user_session.destroy
    end
    
    def find_user_session
      @user_session = current_user_session
    end
    
    def new_user_session
      @user_session = UserSession.new
    end
end
