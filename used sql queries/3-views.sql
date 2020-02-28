--A view to use when doing reports at the website showing the total vouchers.
CREATE VIEW unused_vouchers_statistic AS 
SELECT to_char(expire_date, 'YYYY/MM')AS Expire_month,COUNT(*) AS amount_vouchers FROM vouchers WHERE used=false
GROUP BY to_char(expire_date, 'YYYY/MM')
ORDER BY Expire_month ASC;
--
SELECT * FROM unused_vouchers_statistic;

--A view to use when calculate the financial return of the concerts.
CREATE VIEW concerts_profit_statistic AS
SELECT concert_id,spending,ticket_price * sold_tickets AS earning,ticket_price * sold_tickets-spending AS profit,sold_tickets+voucher_tickets+remaining_tickets AS total_amount_tickets,sold_tickets,voucher_tickets
FROM(
SELECT 
con.concert_id,
con.spending,
con.remaining_tickets,
con.ticket_price,
(SELECT count(*) FROM tickets WHERE ticket_id IN (SELECT ticket_id FROM pesetas_tickets) AND concert_id=con.concert_id) AS sold_tickets,
(SELECT count(*) FROM tickets WHERE ticket_id IN (SELECT ticket_id FROM voucher_tickets) AND concert_id=con.concert_id) AS voucher_tickets
FROM tickets AS tic,
concerts AS con
group by con.concert_id,con.ticket_price,con.spending) AS result;