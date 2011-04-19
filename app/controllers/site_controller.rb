class SiteController < ApplicationController

  before_filter :get_uuid, :only => [:home]

  def home
    results = CartoDB::Connection.query <<-SQL
      SELECT
             uuid,
             p.cartodb_id as plot_cartodb_id,
             vrm.name,
             ST_Area(p.the_geom::geography) as size,
             ST_AsGeojson(p.the_geom) as the_geom
      FROM variable_rate_maps vrm
      INNER JOIN plots p ON p.variable_rate_maps_id = vrm.cartodb_id
      WHERE vrm.uuid = '#{@uuid}'
    SQL

    plots = results.rows || []

    @variable_rate_maps = {
      :uuid => @uuid,
      :variable_rate_maps => plots
    }

  end

end
