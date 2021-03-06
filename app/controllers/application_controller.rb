class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_404
    respond_to do |format|
      format.html do
        render :file => "public/404.html", :status => 404, :layout => false
      end
      format.json do
        render :nothing => true, :status => 404
      end
    end
  end

  def get_uuid
    @uuid = sanitize_sql(params[:uuid])
  end

  def sanitize_sql(string)
    string.gsub(/\\/, '\&\&').gsub(/'/, "''") if string.present?
  end

end
