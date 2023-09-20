class GeospatialController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    json_data = JSON.parse(request.body.read)
    ticket_data, excavator_data = GeospatialJsonExtractor.extract(json_data)

    ticket = Ticket.new(ticket_data)
    if ticket.save
      excavator_data[:ticket_id] = ticket.id

      excavator = Excavator.new(excavator_data)

      if excavator.save
        render json: { message: "Successfully saved!" }, status: :created
      else
        render json: { errors: excavator.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
