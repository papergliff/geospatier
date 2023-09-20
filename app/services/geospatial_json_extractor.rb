class GeospatialJsonExtractor
  def self.extract(json_data)
    ticket_data = {
      request_number: json_data["RequestNumber"],
      sequence_number: json_data["SequenceNumber"],
      request_type: json_data["RequestType"],
      request_action: json_data["RequestAction"],
      response_due_date_time: json_data.dig("DateTimes", "ResponseDueDateTime"),
      primary_service_area_code: json_data.dig("ServiceArea", "PrimaryServiceAreaCode", "SACode"),
      additional_service_area_codes: "{#{json_data.dig('ServiceArea', 'AdditionalServiceAreaCodes', 'SACode').join(',')}}",
      digsite_info: json_data.dig("ExcavationInfo", "DigsiteInfo", "WellKnownText")
    }

    excavator_data = {
      company_name: json_data.dig("Excavator", "CompanyName"),
      address: [
        json_data.dig("Excavator", "Address"),
        json_data.dig("Excavator", "City"),
        json_data.dig("Excavator", "State"),
        json_data.dig("Excavator", "Zip")
      ].join(", "),
      crew_on_site: json_data.dig("Excavator", "CrewOnsite") == "true"
    }

    [ticket_data, excavator_data]
  end
end
