class SearchsController < ApplicationController
  def municipalities
    render :nothing and return if params.blank? || params[:name].blank?

    name = params[:name].gsub(/\\/, '\&\&').gsub(/'/, "''")

    result = CartoDB::Connection.query <<-SQL
      SELECT municipalities.id as municipality_id,
             municipalities.name as municipality_name,
             provinces.id as province_id,
             provinces.name as province_name
      FROM municipalities
      INNER JOIN provinces ON provinces.id = municipalities.province_id
      WHERE municipalities.name ilike '%#{name}%'
    SQL

    municipalities = result.rows || []

    respond_to do |format|
      format.json{ render :json => municipalities.to_json }
    end
  end
end