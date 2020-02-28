
--Function to cancel a concert.
CREATE FUNCTION cancel_concert(concertId integer,give_vouchers boolean)
RETURNS VOID AS $$
BEGIN
IF concertId IS NOT NULL THEN
IF EXISTS (SELECT * FROM concerts WHERE concert_id=concertId AND cancelled=false) then
    IF give_vouchers = true THEN
    INSERT INTO vouchers (user_id) SELECT user_id FROM tickets WHERE concert_id=concertId AND ticket_id IN (SELECT ticket_id FROM pesetas_tickets);
	END IF;
	UPDATE concerts SET cancelled = true WHERE concert_id=concertId;
	END IF;
	END IF;
	END;
$$ LANGUAGE plpgsql;

--Only a exchangefunction. If needed in the future the changingrate can be edit.
CREATE FUNCTION pesetas_exchanging(money integer)
RETURNS real AS $$
DECLARE
exchangingRate real := 2;
result real := money*exchangingRate;
BEGIN
RETURN result;
END;
$$ language plpgsql;

--A function to create wallet. Separate from create user in case of needed for an admin or another wallet in the future.
CREATE FUNCTION  create_wallet(inputtedUserId integer)
RETURNS VOID AS $$
BEGIN
insert into wallets (user_id) VALUES (inputtedUserId);
END;
$$
LANGUAGE 'plpgsql';
--Function to create user.
CREATE FUNCTION  create_user(newUsername varchar, newPassword varchar, newFirstName varchar, newLastName varchar, newEmail varchar,newRole varchar)
RETURNS VOID AS $$
DECLARE
getUserId integer;
getRoleId integer;
BEGIN
getRoleId =  role_id FROM roles WHERE role = newRole;
insert into users (user_name, password, email, first_name, last_name, role_id)
values (newUsername, newPassword, newEmail, newFirstName, newLastName,getRoleId)  returning user_id into getUserId;
IF (newRole = 'customer') THEN PERFORM
create_wallet(getUserId);
END IF;
END;
$$
LANGUAGE 'plpgsql';

--Function to use to check total tickets sold in a period.
CREATE FUNCTION  total_tickets_in_period(from_date timestamp(6) without time zone,to_date timestamp(6) without time zone)
RETURNS integer AS $$
DECLARE total_tickets integer;
BEGIN
total_tickets =  count(*)  from tickets  where purchase_date > from_date AND purchase_date < to_date;
RETURN total_tickets;
END;
$$
LANGUAGE 'plpgsql';
--Function to get total income in a period.
CREATE FUNCTION  total_income_in_period(from_date timestamp(6) without time zone,to_date timestamp(6) without time zone)
RETURNS integer AS $$
DECLARE total_income integer;
BEGIN
total_income = SUM(total) FROM
(SELECT  count(*),concerts.ticket_price, count(*)*concerts.ticket_price AS total  from tickets, concerts where purchase_date > from_date AND
 purchase_date < to_date
AND concerts.concert_id = tickets.concert_id GROUP BY ticket_price) as sum_total_income;
RETURN total_income;
END; $$
LANGUAGE 'plpgsql';
--Function to get the top ten best selling artists in a period.
CREATE FUNCTION best_selling_artists ( fromDate timestamp(6) without time zone, toDate timestamp(6) without time zone)
RETURNS  TABLE (artist_id integer,artist_name varchar,popularity smallint,tickets_sold bigint) AS $$
BEGIN
RETURN QUERY SELECT artists.artist_id,artists.name,artists.popularity,count(*) as tickets_sold
FROM concerts,artists,tickets
   WHERE
       artists.artist_id= concerts.artist_id AND concerts.concert_id = 
	  tickets.concert_id AND tickets.purchase_date > fromDate AND
 tickets.purchase_date < toDate  GROUP BY artists.artist_id,artists.name,artists.popularity ORDER BY tickets_sold DESC LIMIT 10 ; 
END;  $$
LANGUAGE 'plpgsql';

--Function to buy tickets with vouchers.
CREATE FUNCTION  buy_tickets_with_voucher(new_concert_id integer, new_user_id integer, new_voucher_id integer)
RETURNS VOID AS $$
DECLARE 
get_ticket_id integer;
valid_voucher boolean;
get_expire_date date ;
BEGIN
IF EXISTS (SELECT * FROM concerts where concert_id= new_concert_id AND cancelled=false) THEN
IF EXISTS (SELECT * FROM vouchers WHERE voucher_id = new_voucher_id AND used=false AND user_id=new_user_id) THEN valid_voucher = 'true'; 
END IF;
get_expire_date = expire_date FROM vouchers WHERE  vouchers.voucher_id = new_voucher_id;
IF (valid_voucher = 'true'  AND get_expire_date >= CURRENT_DATE)  THEN
INSERT INTO tickets (concert_id, user_id) VALUES (new_concert_id, new_user_id) returning ticket_id INTO get_ticket_id;
END IF;
IF (get_ticket_id IS NOT NULL) THEN
INSERT INTO voucher_tickets (ticket_id,voucher_id) VALUES (get_ticket_id,new_voucher_id);
UPDATE vouchers set used = true WHERE vouchers.voucher_id = new_voucher_id;
END IF;
END IF;
END;
$$
LANGUAGE 'plpgsql';

--Function to buy tickets with pesetas.
CREATE FUNCTION  buy_tickets_with_pesetas(new_concert_id integer , new_user_id integer)
RETURNS VOID AS $$
DECLARE 
get_ticket_id integer;
actual_ticket_price integer;
get_wallet_balance integer;
BEGIN
IF EXISTS (SELECT * FROM concerts where concert_id= new_concert_id AND cancelled=false) THEN
actual_ticket_price = ticket_price FROM concerts WHERE concerts.concert_id = new_concert_id;
get_wallet_balance = balance FROM wallets WHERE wallets.user_id = new_user_id;
IF (get_wallet_balance >= actual_ticket_price)  THEN
INSERT INTO tickets (concert_id, user_id) VALUES (new_concert_id, new_user_id) returning ticket_id INTO get_ticket_id;
END IF;
IF (get_ticket_id IS NOT NULL) THEN INSERT INTO pesetas_tickets (ticket_id) VALUES (get_ticket_id);
END IF;
IF (get_ticket_id IS NOT NULL) THEN UPDATE wallets set balance = balance-actual_ticket_price WHERE wallets.user_id = new_user_id;
END IF;
END IF;
END;
   $$
LANGUAGE 'plpgsql';
