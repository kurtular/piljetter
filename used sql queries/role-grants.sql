--The databasecreator and developer have full access to the database and creates the customer- and adminroles.

--Create customer
CREATE ROLE customer WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	NOINHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'Um34Kx1bP';

/* When customerrole created in database customer only can login and no other permissions. The five functions
used at the website for the customer have the text SECURITY DEFINER when they were created. It permits users to inherit the grantors 
access to that function. The other grants is these selects on these tables.*/
GRANT SELECT ON TABLE public.artists TO customer;

GRANT SELECT ON TABLE public.cities TO customer;

GRANT SELECT ON TABLE public.concerts TO customer;

GRANT SELECT ON TABLE public.roles TO customer;

GRANT SELECT ON TABLE public.scenes TO customer;

GRANT SELECT ON TABLE public.users TO customer;

GRANT SELECT ON TABLE public.vouchers TO customer;

GRANT SELECT ON TABLE public.wallets TO customer;


--Create admin
CREATE ROLE admin WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	NOINHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 't6Bnw9UYa';

/*Used only login when creating admin. Activated all but delete and truncate as below. The admins at
"piljetter" could have had more restrictions of individual tables as for example wallets in the future */

GRANT EXECUTE ON FUNCTION public.best_selling_artists(fromdate timestamp without time zone, todate timestamp without time zone) TO admin;

GRANT EXECUTE ON FUNCTION public.cancel_concert(concertid integer, give_vouchers boolean) TO admin;

GRANT EXECUTE ON FUNCTION public.total_income_in_period(from_date timestamp without time zone, to_date timestamp without time zone) TO admin;

GRANT EXECUTE ON FUNCTION public.total_tickets_in_period(from_date timestamp without time zone, to_date timestamp without time zone) TO admin;

GRANT EXECUTE ON FUNCTION public.calc_concert_spending() TO admin;

GRANT EXECUTE ON FUNCTION public.calc_concert_ticket_price() TO admin;

GRANT EXECUTE ON FUNCTION public.create_re_pesetas_tickets() TO admin;

GRANT EXECUTE ON FUNCTION public.decrease_concert_remaining_tickets() TO admin;

GRANT EXECUTE ON FUNCTION public.pesetas_charging() TO admin;

GRANT EXECUTE ON FUNCTION public.refund_new_vouchers() TO admin;

GRANT EXECUTE ON FUNCTION public.refund_pesetas() TO admin;

GRANT EXECUTE ON FUNCTION public.buy_tickets_with_pesetas(new_concert_id integer, new_user_id integer) TO admin;

GRANT EXECUTE ON FUNCTION public.buy_tickets_with_voucher(new_concert_id integer, new_user_id integer, new_voucher_id integer) TO admin;

GRANT EXECUTE ON FUNCTION public.create_user(newusername character varying, newpassword character varying, newfirstname character varying, newlastname character varying, newemail character varying, newrole character varying) TO admin;

GRANT EXECUTE ON FUNCTION public.get_tickets(userid integer) TO admin;

GRANT EXECUTE ON FUNCTION public.pesetas_charging_function(userid integer, depositsek integer) TO admin;

GRANT EXECUTE ON FUNCTION public.pesetas_exchanging(money integer) TO admin;

GRANT EXECUTE ON FUNCTION public.create_wallet(inputteduserid integer) TO admin;

GRANT ALL ON SEQUENCE public.artists_artist_id_seq TO admin;

GRANT ALL ON SEQUENCE public.cities_city_id_seq TO admin;

GRANT ALL ON SEQUENCE public.concerts_concert_id_seq TO admin;

GRANT ALL ON SEQUENCE public.pesetas_charging_reg_id_seq TO admin;

GRANT ALL ON SEQUENCE public.pesetas_tickets_reg_id_seq TO admin;

GRANT ALL ON SEQUENCE public.re_pesetas_tickets_reg_id_seq TO admin;

GRANT ALL ON SEQUENCE public.roles_role_id_seq TO admin;

GRANT ALL ON SEQUENCE public.scenes_scene_id_seq TO admin;

GRANT ALL ON SEQUENCE public.tickets_ticket_id_seq TO admin;

GRANT ALL ON SEQUENCE public.users_user_id_seq TO admin;

GRANT ALL ON SEQUENCE public.voucher_tickets_reg_id_seq TO admin;

GRANT ALL ON SEQUENCE public.vouchers_voucher_id_seq TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.wallets TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.vouchers TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.voucher_tickets TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.users TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.tickets TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.scenes TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.roles TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.re_pesetas_tickets TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.pesetas_tickets TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.pesetas_charging TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.concerts TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.cities TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.artists TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.concerts_profit_statistic TO admin;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.unused_vouchers_statistic TO admin;

