class ContentsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_contents, :only => [ :index ]
  
  # GET /contents
  def index
    respond_to do |format|
      format.html # index.html
    end
  end
  
  protected
    def find_contents
      @contents = Content.accessible(current_user).scoped(:order => 'updated_at DESC')
    end
    
    def find_contents_with_query
      find_contents_without_query
      
      if @query = params[:q]
        @contents = @contents.search(@query)
      end
    end
    
    alias_method_chain :find_contents, :query
end
