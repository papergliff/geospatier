require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  describe "GET /tickets/:id" do
    let(:ticket) do
      t = Ticket.new(
        request_number: "12345",
        digsite_info: [
          {:lat=>-81.13390268058475, :lng=>32.07206917625161},
          {:lat=>-81.14660562247929, :lng=>32.04064386441295},
          {:lat=>-81.08858407706913, :lng=>32.02259853170128},
          {:lat=>-81.05322183341679, :lng=>32.02434500961698},
          {:lat=>-81.05047525138554, :lng=>32.042681017283066},
          {:lat=>-81.0319358226746, :lng=>32.06537765335268},
          {:lat=>-81.01202310294804, :lng=>32.078469305179404},
          {:lat=>-81.02850259513554, :lng=>32.07963291684719},
          {:lat=>-81.07759774894413, :lng=>32.07090546831167},
          {:lat=>-81.12154306144413, :lng=>32.08806865844325},
          {:lat=>-81.13390268058475, :lng=>32.07206917625161}
        ]
      )
      allow(t).to receive(:save).and_return(true)
      allow(t).to receive(:id).and_return(1)
      t
    end

    before do
      serialized_digsite_info = ticket.digsite_info.to_json
      mock_row = {"id" => "1", "request_number" => ticket.request_number, "digsite_info" => serialized_digsite_info}
      mock_result = double('Result', first: mock_row, ntuples: 1)

      allow(mock_result).to receive(:[]).with(0).and_return(mock_row)
      allow($pg_conn).to receive(:exec_params).and_return(mock_result)
    end
    

    it "digsite info should be visible on the map" do
      get "/tickets/#{ticket.id}"

      expect(response).to have_http_status(:success)

      assert_select ".leaflet-container"
    end
  end
end
