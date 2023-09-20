class Ticket
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :request_number, :sequence_number, :request_type, 
                :request_action, :response_due_date_time, :primary_service_area_code,
                :additional_service_area_codes, :digsite_info, :updated_at, :created_at
              
  def save
    if valid?
      columns = [
        :request_number, :sequence_number, :request_type, 
        :request_action, :response_due_date_time, :primary_service_area_code,
        :additional_service_area_codes, :digsite_info
      ]

      placeholders = columns.each_with_index.map { |_, i| "$#{i + 1}" }.join(", ")
      sql = "INSERT INTO tickets (#{columns.join(", ")}) VALUES (#{placeholders}) RETURNING id"

      values = columns.map { |column| send(column) }

      result = $pg_conn.exec_params(sql, values)
      self.id = result.first["id"].to_i if result.ntuples > 0

      true
    else
      false
    end
  end
end
