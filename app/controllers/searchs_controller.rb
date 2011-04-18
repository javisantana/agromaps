class SearchsController < ApplicationController
  SIGPAC_SERVER = "http://sigpac.mapa.es/fega/visor/"
  COMUNINDADES="Data.aspx?method=Data&LAYER=COMUNIDADES"
  PROVINCIAS= "Data.aspx?method=Data&LAYER=PROVINCIAS&"
  MUNICIPIOS= "data.aspx?method=Data&LAYER=MUNICIPIOS&"
  POLIGONOS= "data.aspx?method=Data&LAYER=POLIGONOS&"
  PARCELAS = "data.aspx"


  def municipalities
    render :nothing and return if params.blank? || params[:name].blank?

    name = sanitize_sql(params[:name])

    result = CartoDB::Connection.query <<-SQL
      SELECT municipalities.id as municipality_id,
             municipalities.name as municipality_name,
             provinces.id as province_id,
             provinces.name as province_name
      FROM municipalities
      INNER JOIN provinces ON provinces.id = municipalities.province_id
      WHERE municipalities.name ilike '%#{name}% LIMIT 5'
    SQL

    municipalities = result.rows || []

    respond_to do |format|
      format.json{ render :json => municipalities.to_json }
    end
  end

  def plots
    url = URI.parse(SIGPAC_SERVER + PARCELAS)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.get(url.path + "?method=Data&LAYER=PARCELAS&pr=#{params[:province_id]}&mn=#{params[:municipality_id]}&pl=#{params[:polygon_id]}")
    end

    x_min = nil
    y_min = nil
    x_max = nil
    y_max = nil

    doc = Nokogiri::XML(res.body)
    doc.xpath("//dataRow").each do |data_row|
      plot_number = data_row.xpath('code').first.content
      next if plot_number.to_i != params[:plot_number].to_i
      x_min = data_row.xpath('utmRange/xMin').first.content.to_f / 10_000
      y_min = data_row.xpath('utmRange/xMax').first.content.to_f / 10_000
      x_max = data_row.xpath('utmRange/yMin').first.content.to_f / 10_000
      y_max = data_row.xpath('utmRange/yMax').first.content.to_f / 10_000
    end

    raise "Plot number not found" if x_min.blank? || y_min.blank? || x_max.blank? || y_max.blank?

    query = "select ST_AsGeojson(ST_Transform(ST_SetSRID(ST_MakeBox2D(ST_Point(#{x_min},#{y_min}),ST_Point(#{x_max},#{y_max})),23030),4326)) as geom"
    result = CartoDB::Connection.query(query)
    respond_to do |format|
      format.json{ render :json => result[:rows][0][:geom] }
    end
  end
end
