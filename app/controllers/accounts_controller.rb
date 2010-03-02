class AccountsController < ApplicationController
  before_filter :require_authentic

  before_filter :update_user, :only => [ :update ]
  
  # GET /account
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /account/edit
  def edit
    add_breadcrumb t('edit')

    respond_to do |format|
      format.html # edit.html
    end
  end

  # PUT /account
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
    def update_user
      current_user.attributes = params[:user]
    end
end