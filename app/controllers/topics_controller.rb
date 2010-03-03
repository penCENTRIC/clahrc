class TopicsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_forums
  before_filter :find_forum
  
  before_filter :find_topics
  before_filter :find_topic, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :new_topic, :only => [ :new ]
  before_filter :create_topic, :only => [ :create ]
  before_filter :update_topic, :only => [ :update ]
  before_filter :destroy_topic, :only => [ :destroy ]
  
  after_filter :track_topic, :only => [ :create ]
  
  paginate :topics, :name => 'directory', :per_page => 10, :page_path => :directory_topics_path, :only => [ :index ]
  
  # GET /forums/:forum_id/topics
  def index
    add_breadcrumb t('index'), forum_topics_path(@forum)
    
    respond_to do |format|
      format.html {
        if request.xhr?
          render :index, :layout => false
        else
          render :index
        end
      }
    end
  end
  
  # GET /topics/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /topics/new
  def new
    add_breadcrumb t('new'), new_forum_topic_path(@forum)
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /topics/:id/edit
  def edit
    add_breadcrumb t('edit'), edit_topic_path(@topic)
    
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # POST /topics/create
  def create
    if @topic.save
      flash[:notice] = t('created')

      respond_to do |format|
        format.html { redirect_to topic_path(@topic) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /topics/:id
  def update
    if @topic.save
      flash[:notice] = t('updated')

      respond_to do |format|
        format.html { redirect_to topic_path(@topic) }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end
  
  # DELETE /topics/:id
  def destroy
    respond_to do |format|
      format.html { redirect_to topics_path(@topic.forum) }
    end
  end
  
  protected
    def create_topic
      new_asset_attributes = if params[:topic].has_key?(:new_asset_attributes)
        params[:topic].delete(:new_asset_attributes)
      else
        nil
      end

      @topic = @topics.new(params[:topic])

      @topic.user = current_user
      @topic.group = @topic.forum.group

      @topic.new_asset_attributes = new_asset_attributes unless new_asset_attributes.nil?
    end
    
    def destroy_topic
      @topic.destroy
    end
    
    def destroy_topic_with_authority
      if @topic.can_be_destroyed_by?(current_user)
        destroy_topic_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to topic_path(@topic) }
        end
      end
    end
    
    alias_method_chain :destroy_topic, :authority
    
    def directory_topics_path(directory)
      forum_directory_topic_path(@forum, directory)
    end
    
    def find_topic
      if topic = @topics.find_by_id(params[:id].to_i)
        found_topic(topic)
      elsif topic = Topic.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to topic.forum ? forum_topics_path(topic.forum) : topic.group ? group_forums_path(topic.group) : groups_path }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to groups_path }
        end
      end
    end
    
    def new_topic
      @topic = @topics.new
    end
    
    def track_topic
      if @topic.valid?
        TopicActivity.create(:trackable => @topic, :user => current_user, :group => @topic.group, :controller => controller_name, :action => action_name, :access => @topic.access)
      end
    rescue
      nil
    end
    
    def update_topic
      new_asset_attributes = if params[:topic].has_key?(:new_asset_attributes)
        params[:topic].delete(:new_asset_attributes)
      else
        nil
      end
      
      existing_asset_attributes = if params[:topic].has_key?(:existing_asset_attributes)
        params[:topic].delete(:existing_asset_attributes)
      else
        {}
      end
      
      # Update topic first
      @topic.attributes = params[:topic]
      
      @topic.new_asset_attributes = new_asset_attributes unless new_asset_attributes.nil?
      @topic.existing_asset_attributes = existing_asset_attributes
    end
    
    def update_topic_with_authority
      if @topic.can_be_edited_by?(current_user)
        update_topic_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to topic_path(@topic) }
        end
      end
    end
    
    alias_method_chain :update_topic, :authority
end
