CREATE TABLE excavators (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(255),
    address TEXT,
    crew_on_site BOOLEAN,
    ticket_id INTEGER,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TRIGGER update_excavators_modtime
BEFORE UPDATE ON excavators
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column(); 
