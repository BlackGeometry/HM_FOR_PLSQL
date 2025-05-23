-- Проверка "Создание платежа" f_create_payment --
DECLARE
v_pay_info_data   t_number_array := t_number_array(1,2,3,4);    
v_payment_id      PAYMENT.PAYMENT_ID%type;
v_pay_cr_sum      number(15,2) := 100000;
v_pay_cr_date     timestamp := systimestamp;
v_pay_cr_cur_id   integer := 643;
v_pay_cr_from_id  integer := 100;
v_p_pay_cr_to_id  integer := 999;
v_pay_table       PAYMENT%ROWTYPE;
v_pay_ct_data     t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'QWERT'),
                                                               t_payment_detail(2, 'ASDFG'),
                                                               t_payment_detail(3, 'ZXCVB')
                                                               );
BEGIN 
    v_payment_id := payment_api_pack.f_create_payment(p_pay_cr_sum     =>  v_pay_cr_sum, 
                                                      p_pay_cr_date    =>  v_pay_cr_date, 
                                                      p_pay_cr_cur_id  =>  v_pay_cr_cur_id,
                                                      p_pay_cr_from_id =>  v_pay_cr_from_id, 
                                                      p_pay_cr_to_id   =>  v_p_pay_cr_to_id,
                                                      p_pay_ct_data    =>  v_pay_ct_data);                                                       
   COMMIT;
      
   SELECT *
   INTO v_pay_table
   FROM PAYMENT
   WHERE PAYMENT_ID = v_payment_id;
   dbms_output.put_line('ID: '|| v_pay_table.PAYMENT_ID || ' TOTAL: '|| v_pay_table.SUMMA || ' CURRENCY_ID: ' || v_pay_table.CURRENCY_ID ||
                        ' FROM_CLIENT_ID: ' || v_pay_table.FROM_CLIENT_ID || ' TO_CLIENT_ID: ' ||v_pay_table.TO_CLIENT_ID ||' STATUS: '|| v_pay_table.STATUS);
   
end;
/

-- Проверка "Сброса платежа" pr_fail_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := 33091105;
v_reset_reason    PAYMENT.STATUS_CHANGE_REASON%type := 3;
v_pay_table       PAYMENT%ROWTYPE;

BEGIN 
    payment_api_pack.pr_fail_payment(p_payment_id    =>  v_payment_id, 
                                     p_reset_reason  =>  v_reset_reason
                                     );                                                                                           
   COMMIT;
      
   SELECT *
   INTO v_pay_table
   FROM PAYMENT
   WHERE PAYMENT_ID = v_payment_id;
   dbms_output.put_line('ID: '|| v_pay_table.PAYMENT_ID || ' TOTAL: '|| v_pay_table.SUMMA || ' CURRENCY_ID: ' || v_pay_table.CURRENCY_ID ||
                        ' FROM_CLIENT_ID: ' || v_pay_table.FROM_CLIENT_ID || ' TO_CLIENT_ID: ' ||v_pay_table.TO_CLIENT_ID ||' STATUS: '|| v_pay_table.STATUS ||
                        ' STATUS_CHANGE_REASON: ' || v_pay_table.STATUS_CHANGE_REASON);
   
end;
/

-- Проверка "Отмены платежа" pr_cancel_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := 33091105;
v_cancel_reason   PAYMENT.STATUS_CHANGE_REASON%type := 2;
v_pay_table       PAYMENT%ROWTYPE;

BEGIN 
    payment_api_pack.pr_cancel_payment(p_payment_id    =>  v_payment_id, 
                                       p_cancel_reason  =>  v_cancel_reason
                                       );                                                                                           
   COMMIT;
      
   SELECT *
   INTO v_pay_table
   FROM PAYMENT
   WHERE PAYMENT_ID = v_payment_id;
   dbms_output.put_line('ID: '|| v_pay_table.PAYMENT_ID || ' TOTAL: '|| v_pay_table.SUMMA || ' CURRENCY_ID: ' || v_pay_table.CURRENCY_ID ||
                        ' FROM_CLIENT_ID: ' || v_pay_table.FROM_CLIENT_ID || ' TO_CLIENT_ID: ' ||v_pay_table.TO_CLIENT_ID ||' STATUS: '|| v_pay_table.STATUS ||
                        ' STATUS_CHANGE_REASON: ' || v_pay_table.STATUS_CHANGE_REASON);
   
end;
/

-- Проверка "Завершения платежа" pr_successful_finish_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := 33091105;
v_pay_table       PAYMENT%ROWTYPE;

BEGIN 
    payment_api_pack.pr_successful_finish_payment(p_payment_id    =>  v_payment_id);                                                                                           
   COMMIT;
      
   SELECT *
   INTO v_pay_table
   FROM PAYMENT
   WHERE PAYMENT_ID = v_payment_id;
   dbms_output.put_line('ID: '|| v_pay_table.PAYMENT_ID || ' TOTAL: '|| v_pay_table.SUMMA || ' CURRENCY_ID: ' || v_pay_table.CURRENCY_ID ||
                        ' FROM_CLIENT_ID: ' || v_pay_table.FROM_CLIENT_ID || ' TO_CLIENT_ID: ' ||v_pay_table.TO_CLIENT_ID ||' STATUS: '|| v_pay_table.STATUS ||
                        ' STATUS_CHANGE_REASON: ' || v_pay_table.STATUS_CHANGE_REASON);
   
end;
/

-- Проверка "Данных платежа" pr_insert_or_update_payment_detail --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := 33091106;
v_pay_table       payment_detail%ROWTYPE;
v_pay_ct_data     t_payment_detail_array := t_payment_detail_array(t_payment_detail(81, 'WSXQAZ')
                                                                   );

BEGIN 
    payment_detail_api_pack.pr_insert_or_update_payment_detail(p_payment_id     =>  v_payment_id,
                                                               p_pay_data_data  =>  v_pay_ct_data
                                                               );                                                                                           
   COMMIT;
    
    FOR v_pay_table IN (SELECT * 
                        FROM payment_detail
                        WHERE PAYMENT_ID = v_payment_id
                        ) LOOP  

   dbms_output.put_line('ID: '|| v_pay_table.PAYMENT_ID || ' TIME: '|| v_pay_table.PAYMENT_CREATE_DTIME || ' FIELD_ID: ' || v_pay_table.FIELD_ID ||
                        ' FIELD_VALUE: ' || v_pay_table.FIELD_VALUE );
     END LOOP;
end;
/

-- Проверка "Детали платежа" delete_payment_detail --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := 33091106;
v_pay_table       payment_detail%ROWTYPE;
v_pay_info_data   t_number_array := t_number_array(1);  

BEGIN 
    payment_detail_api_pack.delete_payment_detail(p_payment_id     =>  v_payment_id,
                                                  p_pay_info_data  =>  v_pay_info_data
                                                  );                                                                                           
   COMMIT;
      
    FOR v_pay_table IN (SELECT * 
                        FROM payment_detail
                        WHERE PAYMENT_ID = v_payment_id
                        ) LOOP 

   dbms_output.put_line('ID: '|| v_pay_table.PAYMENT_ID || ' TIME: '|| v_pay_table.PAYMENT_CREATE_DTIME || ' FIELD_ID: ' || v_pay_table.FIELD_ID ||
                        ' FIELD_VALUE: ' || v_pay_table.FIELD_VALUE );
   
        END LOOP;  
end;
/

