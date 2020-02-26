CREATE DATABASE piljetter;
/*A serial can be negative so a check if >0 is created to be sure. Another check if the admin set a correct popularity. Its important
because of its a part of the calculation for the ticket price. NOT NULL is a reoccuring constraint on almost all columns in the database
The id:s is often used in searches and reports but the primary keys are auto indexed in postgres so no extra index at that. On the other
hand name get an index because its often used when displaying concerts and its seldom that admin creates new artists.*/
CREATE TABLE artists (
    artist_id serial primary key CHECK(artist_id >0),
    name varchar(50) NOT NULL,
    popularity smallint NOT NULL,
    CONSTRAINT artists_popularity_check CHECK ((popularity <= 1000 AND popularity > 0))
);
/*A unique constraint to make sure that two cities in one country cannot have the same name. City and country has an index. */
CREATE TABLE cities (
    city_id serial primary key CHECK (city_id >0),
    city varchar(40) NOT NULL,
    country varchar(40) NOT NULL,
	CONSTRAINT cities_unique_city UNIQUE (city,country)
);
/*Constraint to guarantee the rate of the scene is correct because its a part of the ticketpricecalculation. And a check for the capacity
to be positive. It guarantee the uniqueness of the scene so it checks if the adresscombination is unique. A lot of indexed columns here
because of same reasons as artisttable.*/
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
/*Maybe the most important table. It has many foreign keys and it check if the concertdate is greater than currentdate. A lot of checks
to guarantee the calculations is correct at the spending, ticketprice and remainingtickets. Remaining tickets is very important to never go
negative because of the system wont sell more tickets than the capacity. The system dont have a reserved function which means that the first
person to click the buyfunction and get success gets the ticket. Because its used all the time when showing concerts
it has index at many columns. It also guarantee that no artist can be booked twice at the same day. And the same for the scenes. Index on almost
everything.*/
CREATE TABLE concerts (
    concert_id serial primary key CHECK (concert_id>0),
    artist_id int NOT NULL REFERENCES artists(artist_id),
    scene_id int NOT NULL REFERENCES scenes(scene_id),
    date date NOT NULL CHECK(date > current_date),
    time time NOT NULL,
    spending int CHECK (spending>0),
    ticket_price int CHECK (ticket_price>0),
    remaining_tickets int NOT NULL CHECK (remaining_tickets>=0),
    cancelled boolean DEFAULT false NOT NULL,
	CONSTRAINT concerts_date_artist_id_unique UNIQUE (date,artist_id),
	CONSTRAINT concerts_date_scene_id_unique UNIQUE (date,scene_id)
);
/*The table has few roles but in the future its possible to expand this with other roles than admin and customers.*/
CREATE TABLE roles (
    role_id smallserial primary key CHECK (role_id>0),
    role varchar(50) NOT NULL UNIQUE
);
/*Username and email has to be unique separately. Username and password are common used so it has an index.*/
CREATE TABLE users (
    user_id serial primary key CHECK (user_id>0),
    user_name varchar(20) NOT NULL UNIQUE,
    password varchar(30) NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(400) NOT NULL UNIQUE,
    role_id smallint NOT NULL REFERENCES roles(role_id) 
);
/*This table store the transactions. Because of that the exchangerate can be different it stores both "sek" and "pesetas"
beacuse they are not fully dependent of each other. And transactions will never be changed. */
CREATE TABLE pesetas_charging (
    reg_id serial primary key CHECK (reg_id>0),
    user_id int NOT NULL REFERENCES users(user_id),
    deposit_sek int NOT NULL check (deposit_sek>0),
    "time" timestamp NOT NULL DEFAULT now(),
    amount_pesetas int check (amount_pesetas>0)
);
/*This table are commonly used when buying tickets and therefore its not indexed.*/
CREATE TABLE tickets (
    ticket_id serial primary key CHECK (ticket_id>0),
    concert_id int NOT NULL REFERENCES concerts(concert_id),
    user_id int NOT NULL REFERENCES users(user_id),
    purchase_date timestamp NOT NULL DEFAULT now()
);
/*This table are used for keep track of the refunds. Not used so much so no index here.*/
CREATE TABLE re_pesetas_tickets (
    reg_id serial primary key CHECK (reg_id>0),
    ticket_id int UNIQUE NOT NULL REFERENCES tickets(ticket_id),
    refunded_pesetas int NOT NULL DEFAULT 0,
    "time" timestamp NOT NULL DEFAULT now()
);
/* */
CREATE TABLE pesetas_tickets (
    reg_id serial primary key CHECK (reg_id>0),
    ticket_id int UNIQUE NOT NULL REFERENCES tickets(ticket_id)
);
/*Stores all the given vouchers. Not much inserting here but the website do much reading here for the myprofilepage. Therefore the
columns is indexed. A voucher is by default valid for 183 days.*/
CREATE TABLE vouchers (
    voucher_id serial primary key CHECK (voucher_id>0),
    user_id int NOT NULL REFERENCES users(user_id),
    issued_date date NOT NULL DEFAULT current_date,
    expire_date date NOT NULL check(expire_date>issued_date) DEFAULT (current_date+183),
    used boolean DEFAULT false NOT NULL
);
/**/
CREATE TABLE voucher_tickets (
    reg_id serial primary key CHECK (reg_id>0),
    ticket_id int UNIQUE NOT NULL REFERENCES tickets(ticket_id),
    voucher_id int UNIQUE NOT NULL REFERENCES vouchers(voucher_id)
);
/*Check that a user dont efford to buy a ticket. This is indexed because the website show this all the time.*/
CREATE TABLE wallets (
    user_id int primary key CHECK (user_id>0) NOT NULL REFERENCES users(user_id),
    balance int DEFAULT 25 NOT NULL CHECK (balance>=0)
);