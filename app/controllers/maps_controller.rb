class MapsController < ApplicationController

  before_filter :get_uuid, :except => [:index]

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

end
