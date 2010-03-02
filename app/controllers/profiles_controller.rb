class ProfilesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_profile, :only => [ :edit, :update ]

  before_filter :update_profile, :only => [ :update ]

  # GET /profile/edit
  def edit
    add_breadcrumb t('edit'), edit_my_profile_path
    
    respond_to do |format|
      format.html # edit.html
    end
  end
    
  # PUT /profile
  def update
    if @profile.save
      flash[:notice] = t('updated')
      
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
    def find_profile
      @profile = current_user.profile
    end
    
    def update_profile
      @profile.attributes = params[:profile]
    end
end