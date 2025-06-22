CREATE OR REPLACE TRIGGER payment_b_iu_tech_fields
    BEFORE INSERT OR UPDATE ON payment
    FOR EACH ROW
DECLARE 
    v_current_timestump   payment.create_dtime_tech%type := systimestamp;
BEGIN
    IF INSERTING THEN
      :new.create_dtime_tech := v_current_timestump;
    END IF;
      :new.update_dtime_tech  := v_current_timestump;  
END;
/   