CREATE OR REPLACE TRIGGER payment_detail_b_iud_api
    BEFORE INSERT OR UPDATE OR DELETE ON payment_detail 
-- Проверка выполнения DML из API --
BEGIN
  IF INSERTING OR UPDATING THEN
    raise_application_error(payment_detail_api_pack.c_error_code_dml_changes, payment_detail_api_pack.c_error_msg_dml_changes);
  ELSIF DELETING THEN
    raise_application_error(payment_detail_api_pack.c_error_code_delete_obj, payment_detail_api_pack.c_error_msg_delete_obj);
  END IF;
END;
/ 