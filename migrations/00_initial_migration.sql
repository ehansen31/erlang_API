CREATE TABLE contact_us (
    id serial PRIMARY KEY,
    email text NOT NULL,
    message text NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);