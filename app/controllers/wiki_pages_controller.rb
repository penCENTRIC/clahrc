class WikiPagesController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members
  before_filter :find_member
  
  before_filter :find_groups
  before_filter :find_group
  
  before_filter :find_wiki_pages
  before_filter :find_home_wiki_page, :only => [ :index ]
  before_filter :find_wiki_page, :only => [ :show, :edit, :update, :destroy ]
  
  before_filter :new_wiki_page, :only => [ :new ]
  before_filter :create_wiki_page, :only => [ :create ]
  before_filter :update_wiki_page, :only => [ :update ]
  before_filter :destroy_wiki_page, :only => [ :destroy ]
  
  after_filter :track_wiki_page, :only => [ :create ]  
  
  # GET /wiki_pages/:id
  def index
    respond_to do |format|
      format.html { redirect_to @template.path_for_wiki_page(@wiki_page) }
    end
  end
  
  # GET /wiki_pages/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # GET /wiki_pages/new
  def new
    add_breadcrumb t('index'), @template.path_for_wiki_pages(@group || current_user)
    add_breadcrumb t('new'), @template.path_for_new_wiki_page(@group || current_user)
    
    respond_to do |format|
      format.html # new.html
    end
  end
  
  # GET /wiki_pages/:id/edit
  def edit
    add_breadcrumb t('edit'), @template.path_for_edit_wiki_page(@wiki_page)
    
    respond_to do |format|
      format.html # edit.html
    end
  end
  
  # POST /wiki_pages/create
  def create
    if @wiki_page.save
      flash[:notice] = t('created')

      if @group
        current_user.wiki_pages << @wiki_page
      end     
    
      respond_to do |format|
        format.html { redirect_to @template.path_for_wiki_page(@wiki_page) }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end
  
  # PUT /wiki_pages/:id
  def update
    if @wiki_page.save
      flash[:notice] = t('updated')
      
      respond_to do |format|
        format.html { redirect_to @template.path_for_wiki_page(@wiki_page) }
      end
    else
      respond_to do |format|
        format.html { render :show }
      end
    end
  end
  
  # DELETE /wiki_pages/:id
  def destroy
    flash[:notice] = t('destroyed')
    
    respond_to do |format|
      format.html { redirect_to @template.path_for_wiki_pages(@group || current_user) }
    end
  end
  
  protected
    def create_wiki_page
      @wiki_page = @wiki_pages.new(params[:wiki_page])
    end
    
    def destroy_wiki_page
      @wiki_page.destroy
    end

    def destroy_wiki_page_with_authority
      if @wiki_page.can_be_destroyed_by?(current_user)
        destroy_wiki_page_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to @template.path_for_wiki_page(@wiki_page) }
        end
      end
    end
    
    alias_method_chain :destroy_wiki_page, :authority

    def find_home_wiki_page
      if wiki_page = @wiki_pages.find_by_permalink('Home')
        found_wiki_page(wiki_page)
      elsif @group
        redirect_to @group
      elsif @user
        wiki_page = @wiki_pages.create(:title => 'Home', :body => "Welcome to #{@group ? 'the \'' + @group.name + '\'' : @user.full_name + '\'s personal'} wiki!")
        found_wiki_page(wiki_page)
      elsif current_user
        wiki_page = @wiki_pages.create(:title => 'Home', :body => "Welcome to #{@group ? 'the \'' + @group.name + '\'' : current_user.full_name + '\'s personal'} wiki!")
        found_wiki_page(wiki_page)
      else
        redirect_to root_url
      end
    end
    
    def find_wiki_page
      if wiki_page = @wiki_pages.find_by_permalink(params[:id].to_s)
        found_wiki_page(wiki_page)
      else
        redirect_to @template.path_for_new_wiki_page(@group || current_user, :title => params[:id])
      end
    end
    
    def new_wiki_page
      @wiki_page = @wiki_pages.new(:title => (URI.unescape params[:title]).gsub(/_/, ' '))
    end
    
    def track_wiki_page
      if @wiki_page.valid?
        WikiPageActivity.create(:trackable => @wiki_page, :user => current_user, :group => @wiki_page.group, :controller => controller_name, :action => action_name, :access => @wiki_page.access)
      end
    rescue
      nil
    end
    
    def update_wiki_page
      @wiki_page.attributes = params[:wiki_page]
    end
    
    def update_wiki_page_with_authority
      if @wiki_page.can_be_edited_by?(current_user)
        update_wiki_page_without_authority
      else
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to @template.path_for_wiki_page(@wiki_page) }
        end
      end
    end
    
    alias_method_chain :update_wiki_page, :authority
end