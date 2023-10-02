class DigsiteFetcher
  class << self
    def all
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

      $pg_conn.exec_params(sql)
    end

    def polygon_points(ticket_id)
      sql = <<-SQL
      SELECT 
        jsonb_agg(jsonb_build_object('lat', ST_Y(geom), 'lng', ST_X(geom))) AS polygon_points,
        jsonb_build_array(ST_Y(ST_Centroid(digsite_info)), ST_X(ST_Centroid(digsite_info))) AS centroid
      FROM 
        tickets,
        LATERAL generate_series(1, ST_NPoints(ST_ExteriorRing(digsite_info))) as seq,
        LATERAL (SELECT ST_PointN(ST_ExteriorRing(digsite_info), seq) as geom) as subquery
      WHERE 
        id = $1
      GROUP BY 
        digsite_info;
      SQL

      result = $pg_conn.exec_params(sql, [ticket_id])

      if result.ntuples > 0
        digsite_info = result.first

        polygon_points = JSON.parse(digsite_info['polygon_points'])
        centroid = JSON.parse(digsite_info['centroid'])
    
        { polygon_points: polygon_points, centroid: centroid }
      else
        nil
      end
    end
  end
end 