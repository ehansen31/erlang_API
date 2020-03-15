CREATE TABLE accounts(
    id serial PRIMARY KEY,
    email text NOT NULL,
    uuid text NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX uuid_unique_index on accounts(uuid);
CREATE UNIQUE INDEX email_unique_index on accounts(email);