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

CREATE FUNCTION  create_user(IN new_username varchar, IN new_password varchar, IN new_first_name varchar, IN new_last_name varchar, IN new_email varchar)
RETURNS VOID AS $$
DECLARE get_user_id integer;
DECLARE get_role_id integer;
BEGIN
get_role_id =  role_id FROM roles WHERE role = 'user';
insert into users (user_name, password, email, first_name, last_name, role_id)
values (new_username, new_password, new_email, new_first_name, new_last_name,get_role_id)  returning user_id into get_user_id;
insert into wallets (user_id) VALUES (get_user_id);
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION  buytickets(IN new_concert_id integer ,IN new_user_id integer, IN new_voucher_id integer)
RETURNS VOID AS $$
DECLARE get_ticket_id integer;
DECLARE actual_ticket_price integer;
DECLARE get_wallet_balance integer;
DECLARE used_voucher boolean;
DECLARE get_expire_date date ;
BEGIN
actual_ticket_price = ticket_price FROM concerts WHERE concerts.concert_id = new_concert_id;
get_wallet_balance = balance FROM wallets WHERE wallets.user_id = new_user_id;
used_voucher = used FROM vouchers WHERE vouchers.voucher_id = new_voucher_id;
get_expire_date = expire_date FROM vouchers WHERE  vouchers.voucher_id = new_voucher_id;
IF (new_voucher_id = 0 AND get_wallet_balance >= actual_ticket_price OR
new_voucher_id>0 AND used_voucher = 'false'  AND get_expire_date >= CURRENT_DATE)  THEN
INSERT INTO tickets (concert_id, user_id) VALUES (new_concert_id, new_user_id) returning ticket_id INTO get_ticket_id;
END IF;


IF (new_voucher_id = 0 AND get_ticket_id <> NULL) THEN INSERT INTO pesetas_tickets (ticket_id) VALUES (get_ticket_id);
END IF;
IF (new_voucher_id >0 AND get_ticket_id <> NULL)  THEN INSERT INTO voucher_tickets (ticket_id,voucher_id) VALUES (get_ticket_id,new_voucher_id);

END IF;
END;
 $$
LANGUAGE 'plpgsql';
