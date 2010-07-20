class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_subdomain, :current_host, :current_user

  protect_from_forgery

  layout 'application'

  filter_parameter_logging :password, :password_confirmation

  theme :current_theme

  before_filter :correct_safari_and_ie_accept_headers

  protected      
    def add_breadcrumb(name, url = '')  
      @breadcrumbs ||= []  
      url = eval(url) if url =~ /_path|_url|@/
      @breadcrumbs << [name, url]  
    end  

    def self.add_breadcrumb(name, url = '', options = {})  
      before_filter options do |controller|  
        controller.send(:add_breadcrumb, name, url)  
      end  
    end

    add_breadcrumb 'Home', '/', :if => Proc.new { |controller| controller.send(:current_subdomain) != "community" }

   def found_asset(asset)
      unless @asset || asset.nil?
        if asset.group
          found_group(asset.group)
        else
          found_member(asset.user)
        end

        @asset = asset

        add_breadcrumb t('assets.index'), @template.path_for_assets(asset.group || asset.user || current_user)
        add_breadcrumb asset.name, @template.path_for_asset(asset)
      end
    end

    def found_forum(forum)
      unless @forum || forum.nil?
        found_group(forum.group)

        @forum = forum

        add_breadcrumb t('forums.index'), group_forums_path(forum.group)
        add_breadcrumb forum.title_to_s, forum_path(forum)
      end
    end

    def found_group(group)
      unless @group || group.nil?
        @group = group  

        add_breadcrumb t('groups.index'), groups_path
        add_breadcrumb group.name_to_s, group_path(group)
      end
    end

    def found_member(user)
      unless @user || user.nil?
        @user = user

        unless current_subdomain == "my"
          add_breadcrumb t('members.index'), members_path
          add_breadcrumb user.name_to_s, member_path(user)
        end
      end
    end

    def found_page(page)
      unless @page || page.nil?
        if page.group
          found_group(page.group)
        else
          found_member(page.user)
        end

        @page = page

        add_breadcrumb t('pages.index'), @template.path_for_pages(page.group || page.user || current_user)
        add_breadcrumb page.title_to_s, @template.path_for_page(page)
      end
    end

    def found_post(post)
      unless @post || post.nil?
        found_member(post.user)

        @post = post

        add_breadcrumb t('posts.index'), post.group ? group_posts_path(post.group) : post.user ? member_posts_path(post.user) : my_posts_path
        add_breadcrumb post.title_to_s, post_path(post)
      end
    end

    def found_topic(topic)
      unless @topic || topic.nil?
        found_forum(topic.forum)

        @topic = topic

        add_breadcrumb t('topics.index'), forum_topics_path(topic.forum)
        add_breadcrumb topic.title_to_s, topic_path(topic)
      end
    end

    def found_wiki_page(wiki_page)
      unless @wiki_page || wiki_page.nil?
        if wiki_page.group
          found_group(wiki_page.group)
        else
          found_member(wiki_page.user)
        end

        @wiki_page = wiki_page

        add_breadcrumb t('wiki_pages.index'), @template.path_for_wiki_pages(wiki_page.group || wiki_page.user || current_user)
        add_breadcrumb wiki_page.title_to_s, @template.path_for_wiki_page(wiki_page)
      end
    end

    def correct_safari_and_ie_accept_headers
      request.accepts.sort!{ |x, y| y.to_s == 'text/javascript' ? 1 : -1 } if request.xhr?
    end

    def current_subdomain
      @current_subdomain ||= request.subdomain
    end

    def current_host
      @current_host ||= request.host
    end

    def current_user_session
      @current_user_session ||= UserSession.find
    end

    def current_theme
      @current_theme ||= (current_subdomain.blank? ? nil : current_subdomain)
    end

    def current_user
      @current_user ||= (current_user_session && current_user_session.user)
    end

    def find_activities
      @activities = case
      when @group
        Activity.accessible(current_user).scoped(:conditions => { :group_id => @group.id }, :order => 'created_at DESC')
      when @user
        @user.activities.accessible(current_user).scoped(:order => 'created_at DESC')
      else
        Activity.accessible(current_user).scoped(:order => 'created_at DESC')
      end
    end

    def find_asset
      if params.has_key?(:asset_id)
        if asset = @assets.find_by_id(params[:asset_id].to_i)
          found_asset(asset)
        elsif asset = Page.find_by_id(params[:asset_id].to_i)
          flash[:warning] = t('assets.not_allowed')

          respond_to do |format|
            format.html { redirect_to asset.group ? group_assets_path(asset.group) : asset.user ? member_assets_path(user) : my_assets_path }
          end
        else
          flash[:warning] = t('assets.not_found')

          respond_to do |format|
            format.html { redirect_to my_assets_path }
          end
        end
      end
    end

    def find_assets
      @assets = case
      when @group
        @group.assets.scoped(:order => 'updated_at DESC')
      when @user
        if @user.friends.include?(current_user) || current_user.id == @user.id
          @user.assets.scoped(:conditions => { :hidden => false, :group_id => nil }, :order => 'updated_at DESC')
        else
          @user.assets.scoped(:conditions => { :private => false, :hidden => false, :group_id => nil }, :order => 'updated_at DESC')
        end
      when current_subdomain == 'my'
        current_user.assets.scoped(:conditions => { :group_id => nil }, :order => 'updated_at DESC')
      else
        Asset.accessible(current_user)
      end
    end

    def find_forum
      if params.has_key?(:forum_id)
        if forum = @forums.find_by_id(params[:forum_id].to_i)
          found_forum(forum)
        elsif forum = Forum.find_by_id(params[:forum_id].to_i)
          flash[:warning] = t('forums.not_allowed')

          respond_to do |format|
            format.html { redirect_to group_forums_path(forum.group) }
          end
        else
          flash[:warning] = t('forums.not_found')

          respond_to do |format|
            format.html { redirect_to @group ? group_forums_path(@group) : groups_path }
          end
        end
      end
    end

    def find_forums
      @forums = case
      when @group
        @group.forums.scoped(:order => 'updated_at DESC')
      else
        Forum.scoped(:conditions => { :group_id => current_user.all_group_ids }, :order => 'updated_at DESC')
      end
    end

    def find_group
      if params.has_key?(:group_id)
        if group = @groups.find_by_id(params[:group_id].to_i)
          found_group(group)
        elsif group = Group.find_by_id(params[:group_id].to_i)
          flash[:warning] = t('groups.not_allowed')

          respond_to do |format|
            format.html { redirect_to groups_path }
          end
        else
          flash[:warning] = t('groups.not_found')

          respond_to do |format|
            format.html { redirect_to groups_path }
          end
        end
      end
    end

    def find_groups
      @groups = case
      when @user
        if current_user.all_group_ids.blank?
          @groups = @user.groups.scoped(:conditions => { :hidden => false }, :order => '`groups`.`name` ASC')
        else
          @groups = @user.groups.scoped(:conditions => [ %Q(hidden = :false OR id IN (:group_ids)), { :false => false, :group_ids => current_user.all_group_ids } ], :order => '`groups`.`name` ASC')
        end
      else
        if current_user.all_group_ids.blank?
          @groups = Group.scoped(:conditions => { :hidden => false }, :order => '`groups`.`name` ASC')
        else
          @groups = Group.scoped(:conditions => [ %Q(hidden = :false OR id IN (:group_ids)), { :false => false, :group_ids => current_user.all_group_ids } ], :order => '`groups`.`name` ASC')
        end
      end        
    end

    def find_member
      if params.has_key?(:member_id)
        if user = @users.find_by_id(params[:member_id].to_i)
          found_member(user)
        elsif user = User.find_by_id(params[:member_id].to_i)
          flash[:warning] = t('members.not_allowed')

          respond_to do |format|
            format.html { redirect_to members_path }
          end
        else
          flash[:warning] = t('members.not_found')

          respond_to do |format|
            format.html { redirect_to members_path }
          end
        end
      end
    end

    def find_members
      @users = case
      when @group
        @group.members.scoped(:include => { :user => :profile }, :order => '`profiles`.`last_name` ASC, `profiles`.`first_name` ASC')
      else
        User.scoped(:include => :profile, :conditions => { :confirmed => true }, :order => '`profiles`.`last_name` ASC, `profiles`.`first_name` ASC')
      end
    end

    def find_page
      if params.has_key?(:page_id)
        if page = @pages.find_by_id(params[:page_id].to_i)
          found_page(page)
        elsif page = Page.find_by_id(params[:page_id].to_i)
          flash[:warning] = t('pages.not_allowed')

          respond_to do |format|
            format.html { redirect_to page.group ? group_pages_path(page.group) : page.user ? member_pages_path(user) : my_pages_path }
          end
        else
          flash[:warning] = t('pages.not_found')

          respond_to do |format|
            format.html { redirect_to my_pages_path }
          end
        end
      end
    end

    def find_pages
      @pages = case
      when @group
        @group.pages.scoped(:order => 'position ASC, updated_at DESC')
      when @user
        if @user.friends.include?(current_user) || current_user.id == @user.id
          @user.pages.scoped(:conditions => { :hidden => false, :group_id => nil }, :order => 'position ASC, updated_at DESC')
        else
          @user.pages.scoped(:conditions => { :private => false, :hidden => false, :group_id => nil }, :order => 'position ASC, updated_at DESC')
        end
      when current_subdomain == 'my'
        current_user.pages.scoped(:conditions => { :group_id => nil }, :order => 'position ASC, updated_at DESC')
      else
        Page.accessible(current_user)
      end
    end

    def find_post
      if params.has_key?(:post_id)
        if post = @posts.find_by_id(params[:post_id].to_i)
          found_post(post)
        elsif post = Page.find_by_id(params[:post_id].to_i)
          flash[:warning] = t('posts.not_allowed')

          respond_to do |format|
            format.html { redirect_to post.user ? member_posts_path(post.user) : my_posts_path }
          end
        else
          flash[:warning] = t('posts.not_found')

          respond_to do |format|
            format.html { redirect_to my_posts_path }
          end
        end
      end
    end

    def find_posts
      @posts = case
      when @user
        if @user.friends.include?(current_user) || current_user.id == @user.id
          @user.posts.scoped(:conditions => { :hidden => false }, :order => 'updated_at DESC')
        else
          @user.posts.scoped(:conditions => { :private => false, :hidden => false }, :order => 'updated_at DESC')
        end
      when current_subdomain == 'my'
        current_user.posts.scoped(:order => 'updated_at DESC')
      else
        Post.accessible(current_user)
      end
    end

    def find_topic
      if params.has_key?(:topic_id)
        if topic = @topics.find_by_id(params[:topic_id].to_i)
          found_topic(topic)
        elsif topic = Topic.find_by_id(params[:topic_id].to_i)
          flash[:warning] = t('topics.not_allowed')

          respond_to do |format|
            format.html { redirect_to topic.forum ? forum_topics_path(topic.forum) : topic.group ? group_forums_path(topic.group) : groups_path }
          end
        else
          flash[:warning] = t('topic.not_found')

          respond_to do |format|
            format.html { redirect_to groups_path }
          end
        end
      end
    end

    def find_topics
      @topics = case
      when @forum
        @forum.topics.scoped(:order => 'updated_at DESC')
      else
        Topic.scoped(:conditions => { :group_id => current_user.all_group_ids }, :order => 'updated_at DESC')
      end
    end

    def find_wiki_pages
      @wiki_pages = case
      when @group
        @group.wiki_pages.scoped(:order => 'position ASC, updated_at DESC')
      when @user
        if @user.friends.include?(current_user) || current_user.id == @user.id
          @user.wiki_pages.scoped(:conditions => { :hidden => false, :group_id => nil }, :order => 'position ASC, updated_at DESC')
        else
          @user.wiki_pages.scoped(:conditions => { :private => false, :hidden => false, :group_id => nil }, :order => 'position ASC, updated_at DESC')
        end
      when current_subdomain == 'my'
        current_user.wiki_pages.scoped(:conditions => { :group_id => nil }, :order => 'position ASC, updated_at DESC')
      else
        WikiPage.accessible(current_user)
      end
    end

    def helpers
      ActionController::Base.helpers
    end

    def redirect_to_stored_location_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Response to XmlHttpRequest should render without layout
    def render_with_xhr_check(options = nil, extra_options = {}, &block)
      if request.xhr?
        if options.nil?
          options = { :template => default_template, :layout => false }
        elsif options.is_a? Hash
          options[:layout] = false
        elsif extra_options.is_a? Hash
          extra_options[:layout] = false
        end

        Rails.logger.debug("[XHR] render(#{options.inspect}, #{extra_options.inspect}, &block)")
      end

      render_without_xhr_check(options, extra_options, &block)
    end

    alias_method_chain :render, :xhr_check

    def require_anonymous
      if current_user
        flash[:warning] = t('require_anonymous')

        redirect_to my_account_path
      end
    end

    def require_authentic
      unless current_user
        flash[:warning] = t('require_authentic')

        store_location_and_redirect_to new_session_url
      end
    end

    def store_location
      session[:return_to] = request.url
    end

    def store_location_and_redirect_to(url)
      store_location
      redirect_to url
    end
end
