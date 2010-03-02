class TagsController < ApplicationController
  before_filter :require_authentic
  
  before_filter :find_tags
  before_filter :find_tag, :only => [ :show ]
  
  # GET /tags
  def index
    respond_to do |format|
      format.html # index.html
    end
  end
  
  # GET /tags/:id
  def show
    respond_to do |format|
      format.html # show.html
    end
  end
  
  protected
    def find_tag
      unless @tag = @tags.find_by_id(params[:id])
        flash[:warning] = t('not_found')
        
        respond_to do |format|
          format.html { redirect_to tags_path }
        end
      end
    end
    
    def find_tags
      @tags = Tag.scoped(:order => 'name ASC')
    end    
end