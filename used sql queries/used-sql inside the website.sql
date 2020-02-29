--To show all concerts in customer page.
SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets
FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id AND c.cancelled = false AND c.date+c.time > current_date+current_time ORDER BY c.date+c.time ASC;

--Searchbar querys.
SELECT DISTINCT country FROM cities ORDER BY country
SELECT DISTINCT city FROM cities ORDER BY city
SELECT DISTINCT name FROM scenes ORDER BY name

--Buy tickets querys
SELECT buy_tickets_with_voucher($_POST[itemId],$_SESSION[userId],$_POST[vouchId]);
SELECT buy_tickets_with_pesetas($_POST[itemId],$_SESSION[userId]);

--To show all concerts in admin page.
SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets,c.cancelled,
    CASE 
    WHEN c.date+c.time >= current_date+current_time then false
    WHEN c.date+c.time < current_date+current_time then true
    END AS passed
    FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
    WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id $filter ORDER BY c.date+c.time ASC;

--Cancel concert
SELECT cancel_concert($_POST[cancelCon],$_POST[extra])
    
--To get user information (userid and balance).
SELECT concat(u.first_name,' ',u.last_name) AS NAME,w.balance FROM users AS u,wallets AS w WHERE u.user_id=w.user_id AND u.user_id = $_SESSION[userId];

--To get the tickets belonging to the active user.
SELECT t.ticket_id,
a.name AS artist_name, s.name AS scene_name, ci.city, ci.country, c.date, c.time, c.ticket_price,
t.purchase_date,
CASE
WHEN t.ticket_id IN(select ticket_id from pesetas_tickets) THEN false
WHEN t.ticket_id IN(select ticket_id from voucher_tickets) THEN true
END AS vouchered
FROM users as u,
artists as a, scenes as s, cities as ci, tickets as t,concerts as c
WHERE t.user_id = u.user_id AND
a.artist_id = c.artist_id AND s.scene_id = c.scene_id AND
ci.city_id = s.city_id AND t.concert_id = c.concert_id AND t.user_id = $_SESSION[userId] ORDER BY c.date;

--To get the vouchers belonging to the active user.
SELECT voucher_id, issued_date, expire_date, used from vouchers WHERE vouchers.user_id = $_SESSION[userId];

--To get user_id and role when logging in.
SELECT u.user_id,r.role FROM users AS u,roles as r WHERE r.role_id=u.role_id AND user_name='$userName' AND password='$password'

--Buy pesetas
INSERT into pesetas_charging (user_id,deposit_sek) Values ($_SESSION[userId],$_POST[kronor]);





