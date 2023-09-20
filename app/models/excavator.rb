class Excavator
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :company_name, :address, :crew_on_site,
                :ticket_id, :updated_at, :created_at

  validates :company_name, :ticket_id, presence: true
              
  def save
    if valid?
      columns = [
        :company_name, :address, :crew_on_site, :ticket_id
      ]
  
      placeholders = columns.each_with_index.map { |_, i| "$#{i + 1}" }.join(", ")
      sql = "INSERT INTO excavators (#{columns.join(", ")}) VALUES (#{placeholders}) RETURNING id"

      values = columns.map { |column| send(column) }

      result = $pg_conn.exec_params(sql, values)
      self.id = result.first["id"].to_i if result.ntuples > 0
      true
    else
      false
    end
  end
end
