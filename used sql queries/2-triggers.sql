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