/*funkar*/
CREATE VIEW unused_vouchers_statistic AS 
SELECT to_char(expire_date, 'YYYY/MM')AS Expire_month,COUNT(*) AS amount_vouchers FROM vouchers WHERE used=false
GROUP BY to_char(expire_date, 'YYYY/MM')
ORDER BY Expire_month ASC;
--
SELECT * FROM unused_vouchers_statistic;

/*funkar*/
CREATE VIEW concerts_profit_statistic AS
SELECT tic.concert_id,art.name AS artist_name,
con.spending,
count(*)*con.ticket_price as earning,
(count(*)*con.ticket_price-con.spending) as profit,
concat(con.date,' ',con.time) AS concert_time  
FROM tickets as tic,concerts as con, artists as art
where tic.ticket_id IN (SELECT ticket_id FROM pesetas_tickets)
AND con.concert_id = tic.concert_id
AND con.artist_id = art.artist_id
group by tic.concert_id,concert_time,art.artist_id,con.ticket_price,con.spending