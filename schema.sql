CREATE TABLE peaks (
id serial PRIMARY KEY,
name text NOT NULL,
elevation integer NOT NULL,
prominence integer NOT NULL,
isolation decimal(6,2),
parent text,
county text NOT NULL,
quad text NOT NULL,
state char(2) NOT NULL
);

CREATE TABLE users (
id serial PRIMARY KEY,
username varchar(50) UNIQUE NOT NULL,
password varchar(100) NOT NULL
);

CREATE TABLE ascents (
id serial PRIMARY KEY,
user_id integer NOT NULL REFERENCES users(id) ON DELETE CASCADE,
peak_id integer NOT NULL REFERENCES peaks(id) ON DELETE CASCADE,
"date" date NOT NULL,
note text
);
