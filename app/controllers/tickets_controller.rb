class TicketsController < ApplicationController
  def show
    result = $pg_conn.exec_params('SELECT ST_AsText(digsite_info) as digsite_info FROM tickets WHERE id = $1 LIMIT 1', [params[:id]])
  
    if result.ntuples > 0
      # TODO: following to service:
      # Convert the digsite_info from WKT to an array of points
      wkt_data = result[0]['digsite_info']
      # TODO: reimagine following without global variables if possible
      @polygon_points = wkt_data.gsub("POLYGON((", "").gsub("))", "").split(",").map do |point|
        lat, lon = point.split(" ")
        { lat: lat.to_f, lng: lon.to_f }
      end

      avg_longitude = @polygon_points.sum { |coord| coord[:lat] } / @polygon_points.size
      avg_latitude = @polygon_points.sum { |coord| coord[:lng] } / @polygon_points.size

      @centroid = [avg_longitude, avg_latitude]
    else
      flash[:alert] = "Ticket not found"
      redirect_to tickets_path
    end
  end
  
  
end