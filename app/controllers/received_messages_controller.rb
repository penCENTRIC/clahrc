class ReceivedMessagesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_received_messages
  before_filter :find_received_message, :only => [ :show, :destroy, :reply ]

  before_filter :read_received_message, :only => [ :show ]
  before_filter :destroy_received_message, :only => [ :destroy ]

  before_filter :find_unread_received_messages, :only => [ :unread ]
  
  paginate :received_messages, :name => 'directory', :per_page => 10, :path => :directory_received_messages_path, :only => [ :index, :unread ]
  
  # GET /messages
  def index
    add_breadcrumb t('index'), my_received_messages_path
    
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /messages/:id
  def show
    add_breadcrumb t('index'), my_received_messages_path
    add_breadcrumb @received_message.subject_to_s, my_received_message_path(@received_message)
    
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # DELETE /messages/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to my_received_messages_path }
    end
  end
  
  # GET /messages/unread
  def unread
    add_breadcrumb t('index'), my_received_messages_path
    add_breadcrumb t('unread'), unread_my_received_messages_path
    
    respond_to do |format|
      format.html # unread.html
    end
  end  
  # GET /messages/:id/reply
  def reply
    add_breadcrumb t('index'), my_received_messages_path
    add_breadcrumb @received_message.subject_to_s, my_received_message_path(@received_message)
    add_breadcrumb t('reply'), reply_my_received_message_path(@received_message)

    @message = Message.new(:subject => "#{@received_message.subject_to_s.sub(/^(Re: )*/, 'Re: ')}").from(current_user).to(@received_message.recipients - [ current_user ] + [ @received_message.sender ])
    
    respond_to do |format|
      format.html # new.html
    end
  end

  protected
    def destroy_received_message
      @received_message.destroy
    end
    
    def find_user
      current_user = current_user
    end
    
    def find_received_message
      unless @received_message = @received_messages.find_by_id(params[:id])
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to my_received_messages_path }
        end
      end
    end
    
    def find_received_messages
      @received_messages = current_user.received_messages.scoped(:order => 'created_at DESC')
    end
    
    def find_unread_received_messages
      @received_messages = current_user.received_messages.scoped(:conditions => { :read => false }, :order => 'created_at DESC')
    end
    
    def read_received_message
      @received_message.read!
    end
    
  private
    def directory_received_messages_path(directory)
      case
      when params[:action] == 'unread'
        unread_my_directory_received_messages_path(directory)
      else
        my_directory_received_messages_path(directory)
      end
    end
end
