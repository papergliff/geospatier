class TicketsController < ApplicationController
  def index
    sql = <<-SQL
      SELECT 
        tickets.id as ticket_id,
        tickets.request_number,
        tickets.request_type,
        excavators.company_name,
        excavators.crew_on_site
      FROM
        tickets
      JOIN
        excavators ON tickets.id = excavators.ticket_id;
    SQL
  
    @result = $pg_conn.exec_params(sql)
  end

  def show
    sql = <<-SQL
      SELECT 
        ST_AsGeoJSON(digsite_info) as digsite_info,
        ST_AsGeoJSON(ST_Centroid(digsite_info)) as centroid
      FROM 
        tickets 
      WHERE 
        id = $1 
      LIMIT 1
    SQL

    result = $pg_conn.exec_params(sql, [params[:id]])
  
    if result.ntuples > 0
      digsite_json = JSON.parse(result[0]['digsite_info'])
      centroid_json = JSON.parse(result[0]['centroid'])

      @polygon_points = digsite_json['coordinates'][0].map do |lon, lat|
        { lat: lat, lng: lon }
      end

      lon, lat = centroid_json['coordinates']
      @centroid = [lat, lon]
    else
      flash[:alert] = "Ticket not found"
      redirect_to tickets_path
    end
  end
end
