/*funkar to buy 100 tickets with pesetas*/
DO
$$
DECLARE
concertID integer;
userId integer;
BEGIN
FOR i IN 1..100 LOOP
concertID := (SELECT concert_id FROM concerts WHERE ticket_price <5000 ORDER BY RANDOM() limit(1));
userId := (SELECT user_id from wallets where balance > 5000 ORDER BY RANDOM() limit(1));
perform buy_tickets_with_pesetas(concertID,userID);
RAISE notice 'USER that have id: % bought a ticket for the concert that have id: %',userID,concertID;
END LOOP;
END;
$$

/*to buy 100 tickets using vouchers*/
DO
$$
DECLARE
voucherId integer;
userId integer;
concertId integer;
BEGIN
FOR i IN 1..100 LOOP
concertId := (SELECT concert_id FROM concerts ORDER BY RANDOM() limit(1));
SELECT voucher_id,user_id INTO voucherId,userID from vouchers where used=false ORDER BY RANDOM() limit(1);
perform buy_tickets_with_voucher(concertId,userId,voucherId);
RAISE notice 'USER that have id: % bought a ticket for the concert that have id: % by using the voucher with id: %',userID,concertID,voucherId;
END LOOP;
END;
$$