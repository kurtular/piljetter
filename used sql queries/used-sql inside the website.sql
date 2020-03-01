--If a query is missing it can be found in the php-pages folder.

--ADMIN

--To show all concerts in admin page.
SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets,c.cancelled,
    CASE 
    WHEN c.date+c.time >= current_date+current_time then false
    WHEN c.date+c.time < current_date+current_time then true
    END AS passed
    FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
    WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id $filter ORDER BY c.date+c.time ASC;

--Show info about concert for admin
SELECT * FROM concerts_profit_statistic WHERE concert_id= $_POST[overview]

--Cancel concert
SELECT cancel_concert($_POST[cancelCon],$_POST[extra])

--Create a new concert
INSERT INTO concerts (artist_id,scene_id,date,time,remaining_tickets) 
VALUES ('$_POST[artId]','$_POST[sceId]','$_POST[date]','$_POST[time]','$_POST[remTic]')

--Selecting artists when creating concerts
SELECT artist_id,CONCAT_WS(' ','id:',artist_id,'namn:',name,'popularitet:',popularity) AS value FROM artists ORDER BY name

--Selecting cities when creating concerts
SELECT city_id,CONCAT_WS(' ','id:',city_id,'city:',city,'country:',country) AS value FROM cities ORDER BY city

--Selecting scenes when creating concerts
SELECT scene_id,CONCAT_WS(' ','id:',s.scene_id,'namn:',s.name,'renommé:',s.rate,'capcitet:',s.capacity,'adress:',s.address,s.zip_code,(Select CONCAT_WS(' ','(',ci.city,ci.country,')') FROM cities AS ci WHere ci.city_id=s.city_id)) AS value FROM Scenes AS s ORDER BY s.name

 --Add a new artist
 INSERT INTO artists (name,popularity) VALUES ('$_POST[name]','$_POST[pop]')

 --Add a new scene
INSERT INTO scenes (name,rate,capacity,address,zip_code,city_id) VALUES
 ('$_POST[name]','$_POST[rate]','$_POST[cap]','$_POST[address]','$_POST[zip]','$_POST[cityId]')

--Add city
INSERT INTO cities (city,country) VALUES ('$_POST[city]','$_POST[country]')

--Create a new admin
SELECT create_user('$_POST[uname]','$_POST[psw]','$_POST[fname]','$_POST[lname]','$_POST[email]','admin')

--Get userinformation about admin
SELECT concat(u.first_name,' ',u.last_name) AS NAME FROM users AS u WHERE u.user_id = $_SESSION[userId]

--Show statistic about total income and amount sold tickets
SELECT * FROM total_income_tickets_amount WHERE date >= '$_POST[fSold]' AND date <= '$_POST[tSold]'

--Showing the best selling artists statistic
SELECT CONCAT_WS(' ','#',artist_id,artist_name)AS artist,tickets_sold FROM best_selling_artists('$_POST[fBest]','$_POST[tBest]')

--CUSTOMER

--To show all concerts in customer page.
SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets
FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id AND c.cancelled = false AND c.date+c.time > current_date+current_time ORDER BY c.date+c.time ASC;

--Buy tickets querys
SELECT buy_tickets_with_voucher($_POST[itemId],$_SESSION[userId],$_POST[vouchId]);
SELECT buy_tickets_with_pesetas($_POST[itemId],$_SESSION[userId]);

--To get user information (userid and balance).
SELECT concat(u.first_name,' ',u.last_name) AS NAME,w.balance FROM users AS u,wallets AS w WHERE u.user_id=w.user_id AND u.user_id = $_SESSION[userId];

--To get the tickets belonging to the active user.
SELECT * FROM get_tickets($_SESSION[userId]);

--To get the vouchers belonging to the active user.
SELECT voucher_id, issued_date, expire_date, used from vouchers WHERE vouchers.user_id = $_SESSION[userId];

--Create a new user
SELECT create_user('$userName', '$password', '$firstName', '$lastName', '$email', '$customerRole')

--Buy pesetas
SELECT pesetas_charging_function($_SESSION[userId],$_POST[kronor]);

--SEARCH
SELECT DISTINCT country FROM cities ORDER BY country
SELECT DISTINCT city FROM cities ORDER BY city
SELECT DISTINCT name FROM scenes ORDER BY name

--Adminsearch
SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets,c.cancelled,
    CASE 
    WHEN c.date+c.time >= current_date+current_time then false
    WHEN c.date+c.time < current_date+current_time then true
    END AS passed
    FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
    WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id $filter ORDER BY c.date+c.time ASC;

--Custsearch
SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets
        FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
        WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id AND c.cancelled = false AND c.date+c.time > current_date+current_time $filter ORDER BY c.date+c.time ASC;

--LOGIN
--To get user_id and role when logging in.
SELECT u.user_id,r.role FROM users AS u,roles as r WHERE r.role_id=u.role_id AND user_name='$userName' AND password='$password'