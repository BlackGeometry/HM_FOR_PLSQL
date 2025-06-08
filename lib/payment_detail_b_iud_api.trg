CREATE OR REPLACE TRIGGER payment_detail_b_iud_api
    BEFORE INSERT OR UPDATE OR DELETE ON payment_detail 
-- Проверка выполнения DML из API --
BEGIN
    payment_detail_api_pack.pr_dml_api_check();
END;
/ 