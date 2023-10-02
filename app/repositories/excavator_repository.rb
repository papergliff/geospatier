class ExcavatorRepository
  class << self
    def create(attributes)
      columns = attributes.keys
      placeholders = columns.map.with_index(1) { |_, idx| "$#{idx}" }.join(", ")

      sql = <<~SQL
        INSERT INTO excavators (#{columns.join(", ")})
        VALUES (#{placeholders})
        RETURNING id
      SQL

      begin
        result = $pg_conn.exec_params(sql, attributes.values)
        result.first
      rescue PG::Error => exception
        false
      end
    end
  end
end
