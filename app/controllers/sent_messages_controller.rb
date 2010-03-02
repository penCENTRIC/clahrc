class SentMessagesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_sent_messages
  before_filter :find_sent_message, :only => [ :show, :destroy ]

  before_filter :destroy_sent_message, :only => [ :destroy ]
  
  paginate :sent_messages, :name => 'directory', :per_page => 10, :path => :my_directory_sent_messages_path, :only => [ :index ]
  
  # GET /messages/sent
  def index
    add_breadcrumb t('received_messages.index'), my_received_messages_path
    add_breadcrumb t('index'), my_sent_messages_path
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /messages/sent/:id
  def show
    add_breadcrumb t('received_messages.index'), my_received_messages_path
    add_breadcrumb t('index'), my_sent_messages_path
    add_breadcrumb @sent_message.subject_to_s, my_sent_message_path(@sent_message)
    
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # DELETE /messages/sent/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to my_sent_messages_path }
    end
  end
  
  protected
    def destroy_sent_message
      @sent_message.destroy
    end
    
    def find_user
      current_user = current_user
    end
    
    def find_sent_message
      unless @sent_message = @sent_messages.find_by_id(params[:id])
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to my_sent_messages_path }
        end
      end
    end
    
    def find_sent_messages
      @sent_messages = current_user.sent_messages.scoped(:order => 'created_at DESC')
    end
end
