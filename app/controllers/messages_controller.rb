class MessagesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member
  
  before_filter :find_groups
  before_filter :find_group
  
  before_filter :new_message, :only => [ :new ]
  before_filter :create_message, :only => [ :create ]
  
  # GET /groups/:group_id/messages/new
  # GET /members/:member_id/messages/new
  def new
    add_breadcrumb t('new'), @user ? new_member_message_path(@user) : new_group_message_path(@group)
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # POST /groups/:group_id/messages
  # POST /members/:member_id/messages
  def create
    if @message.save
      flash[:notice] = t('created')
      
      respond_to do |format|
        format.html { redirect_to @user ? member_path(@user) : group_path(@group) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  protected
    def create_message
      @message = Message.new(params[:message].slice(:subject, :body)).from(current_user).to(@user || (@group.members - [ current_user ]))
    end
    
    def new_message
      @message = Message.new.to(@user || (@group.members - [ current_user ]))
    end
end
