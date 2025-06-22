CREATE OR REPLACE TRIGGER payment_b_d_restrict
    BEFORE DELETE ON payment
BEGIN
    payment_common_pack.pr_without_api_dml_check();
END;
