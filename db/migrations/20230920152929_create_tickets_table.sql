CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    request_number VARCHAR(255),
    sequence_number VARCHAR(255),
    request_type VARCHAR(255),
    request_action VARCHAR(255),
    response_due_date_time DATE,
    primary_service_area_code VARCHAR(255),
    additional_service_area_codes VARCHAR[] NOT NULL DEFAULT '{}',
    digsite_info GEOMETRY(POLYGON, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX index_tickets_on_request_number ON tickets (request_number);

CREATE TRIGGER update_tickets_modtime
BEFORE UPDATE ON tickets
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

