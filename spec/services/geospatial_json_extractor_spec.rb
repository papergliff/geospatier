require 'rails_helper'

RSpec.describe GeospatialJsonExtractor do
  describe '.extract' do
    let(:valid_json) do
      {
        "RequestNumber" => "1234",
        "SequenceNumber" => "5678",
        "RequestType" => "Normal",
        "RequestAction" => "Test",
        "DateTimes" => { "ResponseDueDateTime" => "2022-01-01T10:00:00" },
        "ServiceArea" => {
          "PrimaryServiceAreaCode" => { "SACode" => "123" },
          "AdditionalServiceAreaCodes" => { "SACode" => ["123", "124"] }
        },
        "ExcavationInfo" => { "DigsiteInfo" => { "WellKnownText" => "Test WKT" } },
        "Excavator" => {
          "CompanyName" => "Test Co",
          "Address" => "123 Test St",
          "City" => "Test City",
          "State" => "TS",
          "Zip" => "12345",
          "CrewOnsite" => "true"
        }
      }
    end

    it 'correctly extracts ticket and excavator data from valid JSON' do
      ticket_data, excavator_data = GeospatialJsonExtractor.extract(valid_json)
      
      expect(ticket_data).to include(
        request_number: "1234",
        sequence_number: "5678",
        request_type: "Normal",
      )

      expect(excavator_data).to include(
        company_name: "Test Co",
        address: "123 Test St, Test City, TS, 12345",
        crew_on_site: true
      )
    end

    it 'handles missing fields gracefully' do
      valid_json["Excavator"].delete("CompanyName")
      
      ticket_data, excavator_data = GeospatialJsonExtractor.extract(valid_json)
      
      expect(excavator_data).to include(
        company_name: nil
      )
    end
  end
end
