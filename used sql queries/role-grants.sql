--Customer grants 
GRANT EXECUTE ON FUNCTION public.buy_tickets_with_pesetas(new_concert_id integer, new_user_id integer) TO customer;

GRANT EXECUTE ON FUNCTION public.buy_tickets_with_voucher(new_concert_id integer, new_user_id integer, new_voucher_id integer) TO customer;

GRANT EXECUTE ON FUNCTION public.create_user(newusername character varying, newpassword character varying, newfirstname character varying, newlastname character varying, newemail character varying, newrole character varying) TO customer;

GRANT EXECUTE ON FUNCTION public.create_wallet(inputteduserid integer) TO customer;

GRANT EXECUTE ON FUNCTION public.get_tickets(userid integer) TO customer;

GRANT EXECUTE ON FUNCTION public.pesetas_charging_function(userid integer, depositsek integer) TO customer;

GRANT EXECUTE ON FUNCTION public.pesetas_exchanging(money integer) TO customer;
GRANT ALL ON SEQUENCE public.pesetas_charging_reg_id_seq TO customer;

GRANT ALL ON SEQUENCE public.pesetas_tickets_reg_id_seq TO customer;

GRANT ALL ON SEQUENCE public.re_pesetas_tickets_reg_id_seq TO customer;

GRANT ALL ON SEQUENCE public.tickets_ticket_id_seq TO customer;

GRANT ALL ON SEQUENCE public.users_user_id_seq TO customer;

GRANT ALL ON SEQUENCE public.voucher_tickets_reg_id_seq TO customer;
GRANT SELECT ON TABLE public.artists TO customer;

GRANT SELECT ON TABLE public.cities TO customer;

GRANT SELECT ON TABLE public.roles TO customer;

GRANT SELECT ON TABLE public.scenes TO customer;
GRANT SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.concerts TO customer;

GRANT SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.vouchers TO customer;
GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.pesetas_charging TO customer;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.pesetas_tickets TO customer;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.tickets TO customer;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.users TO customer;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.voucher_tickets TO customer;

GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE public.wallets TO customer;
