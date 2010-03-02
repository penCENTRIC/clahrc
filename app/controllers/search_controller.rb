class SearchController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_query
  
  before_filter :find_forums, :only => [ :index, :forums ]
  before_filter :find_forum_results, :only => [ :index, :forums ]

  before_filter :find_groups, :only => [ :index, :groups ]
  before_filter :find_group_results, :only => [ :index, :groups ]

  before_filter :find_members, :only => [ :index, :members ]
  before_filter :find_member_results, :only => [ :index, :members ]

  before_filter :find_pages, :only => [ :index, :pages ]
  before_filter :find_page_results, :only => [ :index, :pages ]

  before_filter :find_posts, :only => [ :index, :posts ]
  before_filter :find_post_results, :only => [ :index, :posts ]

  before_filter :find_topics, :only => [ :index, :topics ]
  before_filter :find_topic_results, :only => [ :index, :topics ]
  
  # GET /search
  def index
    add_breadcrumb 'Search', search_index_path
    
    respond_to do |format|
      format.html
    end
  end

  def forums
    add_breadcrumb 'Search', search_index_path(:q => @query)
    add_breadcrumb 'Forums', forums_search_path(:q => @query)
    
    respond_to do |format|
      format.html
    end
  end
  
  def groups
    add_breadcrumb 'Search', search_index_path(:q => @query)
    add_breadcrumb 'groups', groups_search_path(:q => @query)

    respond_to do |format|
      format.html
    end
  end
  
  def members
    add_breadcrumb 'Search', search_index_path(:q => @query)
    add_breadcrumb 'Members', members_search_path(:q => @query)

    respond_to do |format|
      format.html
    end
  end
  
  def pages
    add_breadcrumb 'Search', search_index_path(:q => @query)
    add_breadcrumb 'Pages', pages_search_path(:q => @query)

    respond_to do |format|
      format.html
    end
  end
  
  def posts
    add_breadcrumb 'Search', search_index_path(:q => @query)
    add_breadcrumb 'Posts', posts_search_path(:q => @query)

    respond_to do |format|
      format.html
    end
  end
  
  def topics
    add_breadcrumb 'Search', search_index_path(:q => @query)
    add_breadcrumb 'Topics', topics_search_path(:q => @query)

    respond_to do |format|
      format.html
    end
  end
  
  private
    def conditions
      @conditions ||= case params[:action].to_sym
      when :index
        { :limit => 3 }
      else
        { :page => params[:page], :per_page => 10 }
      end
    end
    
    def find_query
      @query = params[:q]
    end
    
    def find_forum_results
      @forum_results = @forums.search(@query, conditions)
    end

    def find_forums
      @forums = Forum.accessible(current_user)
    end
    
    def find_group_results
      @group_results = @groups.search(@query, conditions)
    end
    
    def find_groups
      @groups = Group.accessible(current_user)
    end
    
    def find_member_results
      @member_results = User.search(@query, conditions)
    end
    
    def find_members
      @members = User.scoped(:conditions => { :confirmed => true })
    end
    
    def find_page_results
      @page_results = @pages.search(@query, conditions)
    end
    
    def find_pages
      @pages = Page.accessible(current_user)
    end
    
    def find_post_results
      @post_results = @posts.search(@query, conditions)
    end
    
    def find_posts
      @posts = Post.accessible(current_user)
    end
    
    def find_topic_results
      @topic_results = @topics.search(@query, conditions)
    end
        
    def find_topics
      @topics = Topic.accessible(current_user)
    end
end
