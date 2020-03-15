CREATE TABLE accounts(
    id serial PRIMARY KEY,
    email text NOT NULL,
    uuid text NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);