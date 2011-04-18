class MapsController < ApplicationController
  
  before_filter :set_uuid, :except => [:index]
  
  def index
    unless params[:q]
      flash[:alert] = "You should indicate a term for the search" and return
    else
    end
  end
  
  def show
  end
  
  def update
  end
  
  private
  
  def set_uuid
    @uuid = params[:uuid]
    render_404 and return false if @uuid.blank?    
  end
  
end
