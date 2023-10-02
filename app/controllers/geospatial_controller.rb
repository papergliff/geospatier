class GeospatialController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    json_data = JSON.parse(request.body.read)
    ticket_data, excavator_data = GeospatialJsonExtractor.extract(json_data)

    ticket = TicketRepository.create(ticket_data)
    if ticket
      excavator_data[:ticket_id] = ticket["id"]

      excavator = ExcavatorRepository.create(excavator_data)

      if excavator
        render json: { message: "Successfully saved!" }, status: :created
      else
        render json: { errors: "PG error" }, status: :unprocessable_entity
      end
    else
      render json: { errors: "PG error" }, status: :unprocessable_entity
    end
  end
end
