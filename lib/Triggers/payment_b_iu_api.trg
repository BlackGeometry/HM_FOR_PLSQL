CREATE OR REPLACE TRIGGER payment_b_iu_api
    BEFORE INSERT OR UPDATE ON payment
-- Проверка выполнения DML из API --
BEGIN
    payment_api_pack.pr_dml_api_check();
END;
/  