/*funkar*/
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
--
CREATE TRIGGER calc_spending AFTER INSERT ON concerts
for each row execute procedure calc_concert_spending();
/*funkar*/
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
/*funkar*/
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

/*funkar*/
CREATE FUNCTION create_re_pesetas_tickets()
RETURNS TRIGGER AS $$
DECLARE
ticketId integer;
BEGIN
IF NEW.cancelled = true THEN
INSERT INTO re_pesetas_tickets (ticket_id)SELECT ticket_id from pesetas_tickets WHERE ticket_id IN (SELECT ticket_id FROM tickets WHERE concert_id = NEW.concert_id) returning ticket_id INTO ticketId;
UPDATE re_pesetas_tickets set refunded_pesetas = NEW.ticket_price WHERE ticket_id =ticketId; 
END IF;
return null;
END;
$$ LANGUAGE plpgsql;
--
CREATE TRIGGER re_pesetas_tickets_tr AFTER UPDATE OF cancelled ON concerts
FOR EACH ROW EXECUTE PROCEDURE create_re_pesetas_tickets();

/*funkar*/
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

/*funkar*/
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

/*funkar*/
CREATE FUNCTION Pesetas_charging()
RETURNS TRIGGER AS $$
DECLARE
toCharge real := (SELECT pesetas_exchanging(NEW.deposit_sek));
BEGIN
UPDATE pesetas_charging SET amount_pesetas = toCharge WHERE user_id=NEW.user_id;
UPDATE wallets SET balance = balance+toCharge WHERE user_id=NEW.user_id;
RETURN NULL;
END;
$$ language plpgsql;
--
CREATE TRIGGER pesetas_charging_tr AFTER INSERT ON pesetas_charging
FOR EACH ROW EXECUTE PROCEDURE Pesetas_charging();