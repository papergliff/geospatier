require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  describe "GET /tickets/" do
    before do
      mock_row = { "id" => "1", "request_number" => "4005-3333", "request_type" => "Test",
                   "company_name" => "Test Co", "crew_on_site" => "t" }
      mock_result = [mock_row]

      allow($pg_conn).to receive(:exec_params).and_return(mock_result)
    end

    it "Shows ticket and it's link to the map view" do
      get "/tickets"

      expect(response).to have_http_status(:success)

      assert_select "h1", text: "Tickets"
      assert_select ".table--cell", text: "4005-3333"
    end
  end

  describe "GET /tickets/:id" do
    let(:ticket) do
      {
        id: 1,
        request_number: "12345",
        polygon_points: [
            { lat: -81.13390268058475, lng: 32.07206917625161 },
            { lat: -81.14660562247929, lng: 32.04064386441295 },
            { lat: -81.08858407706913, lng: 32.02259853170128 },
        ],
        centroid: [
          -81.13390268058475, 32.07206917625161
        ]
      }
    end

    before do
      serialized_digsite_info = ticket[:polygon_points].to_json
      mock_row = { "id" => "1", "request_number" => ticket[:request_number],
                   "polygon_points" => serialized_digsite_info,
                   "centroid" => ticket[:centroid].to_json }
      mock_result = double('Result', first: mock_row, ntuples: 1)

      allow(mock_result).to receive(:[]).with(0).and_return(mock_row)
      allow($pg_conn).to receive(:exec_params).and_return(mock_result)
    end
    

    it "digsite info should be visible on the map" do
      get "/tickets/#{ticket[:id]}"

      expect(response).to have_http_status(:success)

      assert_select ".leaflet-container"
    end
  end
end
