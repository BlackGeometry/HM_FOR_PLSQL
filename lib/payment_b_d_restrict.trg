CREATE OR REPLACE TRIGGER payment_b_d_restrict
    BEFORE DELETE ON payment
BEGIN
    raise_application_error(payment_api_pack.c_error_code_delete_obj, payment_api_pack.c_error_msg_delete_obj);
END;
/   