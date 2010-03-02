class CommentsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_pages
  before_filter :find_page
  
  before_filter :find_posts
  before_filter :find_post

  before_filter :find_topics
  before_filter :find_topic
    
  before_filter :find_comments
  before_filter :find_comment, :only => [ :edit, :update, :destroy ]
  
  before_filter :create_comment, :only => [ :create ]
  before_filter :update_comment, :only => [ :update ]
  before_filter :destroy_comment, :only => [ :destroy ]
    
  after_filter :track_comment, :only => [ :create ]
  
  # GET /comments/:id/edit
  def edit
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # POST /comments
  def create
    if @comment.save
      flash[:notice] = t('created')
      
      respond_to do |format|
        format.html { redirect_to @page ? page_path(@page) : @post ? post_path(@post) : @topic ? topic_url(@topic) : my_account_path }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
    
  
  # PUT /comments/:id
  def update
    if @comment.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to @comment.commentable }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end
    
  # DELETE /comments/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to @comment.commentable }
    end
  end
      
  protected
    def create_comment
      @comment = @comments.new(params[:comment])
      
      @comment.user_id = current_user.id

      if @group
        @comment.group_id = @group.id
      end
    end
    
    def destroy_comment
      if @comment.can_be_destroyed_by?(current_user)
        @comment.destroy
      else
        flash[:warning] = t('not_allowed')

        respond_to do |format|
          format.html { redirect_to @comment.commentable }
        end
      end  
    end
    
    def find_comment
      if @comment = @comments.find_by_id(params[:id])
        # do nothing
      elsif @comment = Comment.find_by_id(params[:id])
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to @page ? page_path(@page) : @post ? post_path(@post) : @topic ? topic_url(@topic) : my_account_path }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to @page ? page_path(@page) : @post ? post_path(@post) : @topic ? topic_url(@topic) : my_account_path }
        end
      end
    end
    
    def find_comments
      @comments = case
      when @page
        @page.comments.scoped(:order => 'created_at ASC, parent_id ASC, position ASC')
      when @post
        @post.comments.scoped(:order => 'created_at ASC, parent_id ASC, position ASC')
      when @topic
        @topic.comments.scoped(:order => 'created_at ASC, parent_id ASC, position ASC')
      else
        Comment
      end
    end
    
    def track_comment
      if @comment.valid?
        CommentActivity.create(:trackable => @comment, :user => current_user, :group => @comment.group, :controller => controller_name, :action => action_name, :access => @comment.commentable.access)
      end
    rescue
      nil
    end
    
    def update_comment
      if @comment.can_be_edited_by?(current_user)
        @comment.attributes = params[:comment]
      else
        flash[:warning] = t('not_allowed')
        
        respond_to do |format|
          format.html { redirect_to @comment.commentable }
        end
      end
    end
end
