CREATE FUNCTION calc_concert_spending()
RETURNS trigger AS $$
declare
popularity integer := (SELECT popularity FROM artists WHERE artist_id = NEW.artist_id);
rate integer := (SELECT rate FROM scenes WHERE scene_id = NEW.scene_id);
res integer :=((5000*rate)+(2000*popularity));
BEGIN
UPDATE concerts SET spending = res
WHERE concert_id = NEW.concert_id;
RETURN null;
END;
$$ language plpgsql;

CREATE TRIGGER calc_spending AFTER INSERT ON concerts
for each row execute procedure calc_concert_spending();

CREATE FUNCTION calc_concert_ticket_price()
RETURNS trigger AS $$
BEGIN
UPDATE concerts SET ticket_price = ((NEW.spending+(NEW.spending*0.3))/remaining_tickets+1)
WHERE concert_id = NEW.concert_id;
RETURN null;
END;
$$ language plpgsql;

CREATE TRIGGER calc_ticket_price AFTER UPDATE OF spending ON concerts
for each row execute procedure calc_concert_ticket_price();

CREATE FUNCTION decrease_concert_remaining_tickets()
RETURNS trigger AS $$
BEGIN
UPDATE concerts SET remaining_tickets = (remaining_tickets-1)
WHERE concert_id = NEW.concert_id;
RETURN null;
END;
$$ language plpgsql;

CREATE TRIGGER decrease_remaining_tickets AFTER INSERT ON tickets
for each row execute procedure decrease_concert_remaining_tickets();

/**/
CREATE FUNCTION create_re_pesetas_tickets()
RETURNS TRIGGER AS $$
BEGIN
IF NEW.cancelled = true THEN
INSERT INTO re_pesetas_tickets (ticket_id)SELECT ticket_id from pesetas_tickets WHERE ticket_id IN (SELECT ticket_id FROM tickets WHERE concert_id = NEW.concert_id);
END IF;
return null;
END;
$$ LANGUAGE plpgsql;
--
CREATE TRIGGER re_pesetas_tickets_tr AFTER UPDATE OF cancelled ON concerts
FOR EACH ROW EXECUTE PROCEDURE create_re_pesetas_tickets();

/**/
CREATE FUNCTION refund_pesetas()
RETURNS TRIGGER AS $$
declare
concertId integer := (SELECT concert_id FROM tickets where ticket_id=NEW.ticket_id);
userID integer:= (SELECT user_id FROM tickets where ticket_id=NEW.ticket_id);
ticketPrice integer:= (SELECT ticket_price FROM concerts where concert_id=concertId);
BEGIN
UPDATE wallets set balance = (balance+ticketPrice) where user_id=userID;
return null;
END;
$$ LANGUAGE plpgsql;
--
CREATE TRIGGER refund_pesetas_tr AFTER INSERT ON re_pesetas_tickets
FOR EACH ROW EXECUTE PROCEDURE refund_pesetas();

/**/
CREATE FUNCTION refund_new_vouchers()
RETURNS TRIGGER AS $$
BEGIN
IF NEW.cancelled = true THEN
INSERT INTO vouchers (user_id) SELECT user_id FROM tickets WHERE concert_id=NEW.concert_id AND ticket_id IN (SELECT ticket_id FROM voucher_tickets);
END IF;
return null;
END;
$$ LANGUAGE plpgsql;
--
CREATE TRIGGER refund_new_vouchers_tr AFTER UPDATE OF cancelled ON concerts
FOR EACH ROW EXECUTE PROCEDURE refund_new_vouchers();

/*HENRIK*/

CREATE FUNCTION  create_wallet(inputtedUserId integer)
RETURNS VOID AS $$
BEGIN
insert into wallets (user_id) VALUES (inputtedUserId);
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION  new_create_user(newUsername varchar, newPassword varchar, newFirstName varchar, newLastName varchar, newEmail varchar
							,newRole varchar)
RETURNS VOID AS $$
DECLARE getUserId integer;
DECLARE getRoleId integer;
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


CREATE FUNCTION  buytickets(new_concert_id integer ,new_user_id integer, new_voucher_id integer)
RETURNS VOID AS $$
DECLARE get_ticket_id integer;
DECLARE actual_ticket_price integer;
DECLARE get_wallet_balance integer;
DECLARE used_voucher boolean;
DECLARE get_expire_date date ;
BEGIN
actual_ticket_price = ticket_price FROM concerts WHERE concerts.concert_id = new_concert_id;
get_wallet_balance = balance FROM wallets WHERE wallets.user_id = new_user_id;
IF NOT EXISTS (SELECT * FROM voucher_tickets WHERE voucher_id =new_voucher_id) THEN used_voucher = 'false'; 
END IF;
get_expire_date = expire_date FROM vouchers WHERE  vouchers.voucher_id = new_voucher_id;
IF (new_voucher_id = 0 AND get_wallet_balance >= actual_ticket_price OR
new_voucher_id>0 AND used_voucher = 'false'  AND get_expire_date >= CURRENT_DATE)  THEN
INSERT INTO tickets (concert_id, user_id) VALUES (new_concert_id, new_user_id) returning ticket_id INTO get_ticket_id;
END IF;
IF (new_voucher_id =0 AND get_ticket_id IS NOT NULL) THEN INSERT INTO pesetas_tickets (ticket_id) VALUES (get_ticket_id);
END IF;
IF (new_voucher_id =0 AND get_ticket_id IS NOT NULL) THEN UPDATE wallets set balance = balance-actual_ticket_price WHERE wallets.user_id = new_user_id;
END IF;
IF (new_voucher_id >0 AND get_ticket_id IS NOT NULL)  THEN INSERT INTO voucher_tickets (ticket_id,voucher_id) VALUES (get_ticket_id,new_voucher_id);
END IF;
END;
 
 $$
LANGUAGE 'plpgsql';

CREATE FUNCTION  total_tickets_in_period(from_date timestamp(6) without time zone,to_date timestamp(6) without time zone)
RETURNS integer AS $$
DECLARE total_tickets integer;
BEGIN
total_tickets =  count(*)  from tickets  where purchase_date > from_date AND purchase_date < to_date;
RETURN total_tickets;
END;
$$
LANGUAGE 'plpgsql';

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
