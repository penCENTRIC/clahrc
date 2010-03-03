class MembersController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_members, :except => [ :autocomplete ]
  before_filter :find_member, :only => [ :show ]
  
  paginate :users, :name => 'directory', :per_page => 10, :path => :directory_members_path, :only => [ :index ]
    
  # GET /members
  def index
    add_breadcrumb t('index'), members_path

    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /members/:id
  def show    
    respond_to do |format|
      format.html # show.html
    end
  end
  
  # :call-seq:
  #   GET /members/autocomplete?q=<query>
  def autocomplete
    if request.xhr?
      @users = User.find(:all, :include => :profile, :conditions => [ "LOCATE(:q, profiles.full_name) > 0", { :q => params[:q] } ], :limit => params[:limit] || 10)
    
      respond_to do |format|
        format.json { render :json => @users.inject([]) { |result, user| result << { :id => user.id, :name => user.profile.full_name } } }
      end
    else
      respond_to do |format|
        format.json { head :method_not_allowed }
      end
    end
  end
  
  def moderators
    respond_to do |format|
      format.html # moderators
    end
  end
  
  def owners
    respond_to do |format|
      format.html # owners
    end
  end
  
  protected
    def find_member
      if member = @users.find_by_id(params[:id].to_i)
        found_member(member)
      elsif member = Group.find_by_id(params[:id].to_i)
        flash[:warning] = t('not_allowed')
      
        respond_to do |format|
          format.html { redirect_to members_path }
        end
      else
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to members_path }
        end
      end
    end
    
    def find_members_with_query
      find_members_without_query
      
      if @query = params[:q]
        @users = @users.search(@query)
      end
    end
    
    alias_method_chain :find_members, :query
end