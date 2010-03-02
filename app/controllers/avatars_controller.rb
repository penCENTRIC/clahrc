class AvatarsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_avatar, :only => [ :edit, :update ]
  before_filter :update_avatar, :only => [ :update ]

  # GET /avatar/edit
  def edit
    add_breadcrumb t('edit'), edit_my_avatar_path
    
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # PUT /avatar
  def update
    if current_user.save
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
    def find_avatar
      @avatar = current_user.avatar
    end
   
    def update_avatar
      current_user.attributes = params[:user]
    end
end