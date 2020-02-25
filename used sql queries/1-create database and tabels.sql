CREATE DATABASE piljetter;
CREATE TABLE artists (
    artist_id serial primary key CHECK(artist_id >0),
    name varchar(50) NOT NULL,
    popularity smallint NOT NULL,
    CONSTRAINT artists_popularity_check CHECK ((popularity <= 1000 AND popularity > 0))
);

CREATE TABLE cities (
    city_id serial primary key CHECK (city_id >0),
    city varchar(40) NOT NULL,
    country varchar(40) NOT NULL,
	CONSTRAINT cities_unique_city UNIQUE (city,country)
);
CREATE TABLE scenes (
    scene_id serial primary key CHECK (scene_id>0),
    name varchar(100) NOT NULL,
    rate smallint NOT NULL,
    capacity int NOT NULL,
    address varchar(255) NOT NULL,
    zip_code varchar(16) NOT NULL,
    city_id int NOT NULL REFERENCES cities(city_id),
    CONSTRAINT scenes_rate_check CHECK ((rate <= 400 AND rate>0)),
	CONSTRAINT scenes_capacity_check CHECK ((capacity>0)),
	CONSTRAINT scenes_address_unique UNIQUE (address,zip_code,city_id)
);
CREATE TABLE concerts (
    concert_id serial primary key CHECK (concert_id>0),
    artist_id int NOT NULL REFERENCES artists(artist_id),
    scene_id int NOT NULL REFERENCES scenes(scene_id),
    date date NOT NULL CHECK(date >= current_date),
    time time NOT NULL,
    spending int CHECK (spending>0),
    ticket_price int CHECK (ticket_price>0),
    remaining_tickets int NOT NULL CHECK (remaining_tickets>=0),
    cancelled boolean DEFAULT false NOT NULL,
	CONSTRAINT concerts_date_artist_id_unique UNIQUE (date,artist_id),
	CONSTRAINT concerts_date_scene_id_unique UNIQUE (date,scene_id)
);
CREATE TABLE roles (
    role_id smallserial primary key CHECK (role_id>0),
    role varchar(50) NOT NULL UNIQUE
);
CREATE TABLE users (
    user_id serial primary key CHECK (user_id>0),
    user_name varchar(20) NOT NULL UNIQUE,
    password varchar(30) NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(400) NOT NULL UNIQUE,
    role_id smallint NOT NULL REFERENCES roles(role_id) 
);
CREATE TABLE pesetas_charging (
    reg_id serial primary key CHECK (reg_id>0),
    user_id int NOT NULL REFERENCES users(user_id),
    deposit_sek int NOT NULL check (deposit_sek>0),
    "time" timestamp NOT NULL DEFAULT now(),
    amount_pesetas int check (amount_pesetas>0)
);
CREATE TABLE tickets (
    ticket_id serial primary key CHECK (ticket_id>0),
    concert_id int NOT NULL REFERENCES concerts(concert_id),
    user_id int NOT NULL REFERENCES users(user_id),
    purchase_date timestamp NOT NULL DEFAULT now()
);
CREATE TABLE re_pesetas_tickets (
    reg_id serial primary key CHECK (reg_id>0),
    ticket_id int UNIQUE NOT NULL REFERENCES tickets(ticket_id),
    refunded_pesetas int NOT NULL DEFAULT 0,
    "time" timestamp NOT NULL DEFAULT now()
);
CREATE TABLE pesetas_tickets (
    reg_id serial primary key CHECK (reg_id>0),
    ticket_id int UNIQUE NOT NULL REFERENCES tickets(ticket_id)
);
CREATE TABLE vouchers (
    voucher_id serial primary key CHECK (voucher_id>0),
    user_id int NOT NULL REFERENCES users(user_id),
    issued_date date NOT NULL DEFAULT current_date,
    expire_date date NOT NULL check(expire_date>issued_date) DEFAULT (current_date+183),
    used boolean DEFAULT false NOT NULL
);
CREATE TABLE voucher_tickets (
    reg_id serial primary key CHECK (reg_id>0),
    ticket_id int UNIQUE NOT NULL REFERENCES tickets(ticket_id),
    voucher_id int UNIQUE NOT NULL REFERENCES vouchers(voucher_id)
);
CREATE TABLE wallets (
    user_id int primary key CHECK (user_id>0) NOT NULL REFERENCES users(user_id),
    balance int DEFAULT 25 NOT NULL CHECK (balance>=0)
);