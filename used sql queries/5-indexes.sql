CREATE INDEX  users_user_name_index  ON users 
USING hash (user_name);
CREATE INDEX  cities_city_index  ON cities 
USING hash (city);
CREATE INDEX  cities_country_index  ON cities 
USING hash (country);
CREATE INDEX  pesetas_charging_user_id  ON pesetas_charging 
USING hash (user_id);
CREATE INDEX  vouchers_user_id_index  ON vouchers 
USING hash (user_id);
CREATE INDEX  vouchers_expire_date_index  ON vouchers 
USING btree (expire_date);
CREATE INDEX  concerts_artist_id_index  ON concerts 
USING hash (artist_id);
CREATE INDEX  concerts_scene_id_index  ON concerts 
USING hash (scene_id);
CREATE INDEX  concerts_date_index  ON concerts 
USING btree (date);
CREATE INDEX  artists_name_index  ON artists 
USING btree (name);
CREATE INDEX  scenes_name_index  ON scenes 
USING hash (name);
CREATE INDEX  scenes_city_id_index  ON scenes 
USING hash (city_id);
CREATE INDEX  pesetas_tickets_ticket_id_index  ON pesetas_tickets 
USING hash (ticket_id);
CREATE INDEX  voucher_tickets_ticket_id_index  ON voucher_tickets 
USING hash (ticket_id);
CREATE INDEX  tickets_concert_id_index  ON tickets 
USING hash (concert_id);
CREATE INDEX  tickets_user_id_index  ON tickets 
USING hash (user_id);