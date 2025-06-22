-- Проверка "Создание платежа" f_create_payment --
DECLARE
v_payment_id         PAYMENT.PAYMENT_ID%type;
v_pay_cr_sum         number(15,2) := 100000;
v_pay_cr_date        timestamp := systimestamp;
v_pay_cr_cur_id      integer := 643;
v_pay_cr_from_id     integer := 100;
v_p_pay_cr_to_id     integer := 999;
v_pay_table          PAYMENT%ROWTYPE;
v_create_dtime_tech  PAYMENT.CREATE_DTIME_TECH%type;
v_update_dtime_tech  PAYMENT.UPDATE_DTIME_TECH%type;
v_pay_ct_data        t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'QWERT'),
                                                                      t_payment_detail(2, 'ASDFG'),
                                                                      t_payment_detail(3, 'ZXCVB')
                                                                      );
BEGIN 
    v_payment_id := payment_api_pack.f_create_payment(p_pay_cr_sum     =>  v_pay_cr_sum, 
                                                      p_pay_cr_date    =>  v_pay_cr_date, 
                                                      p_pay_cr_cur_id  =>  v_pay_cr_cur_id,
                                                      p_pay_cr_from_id =>  v_pay_cr_from_id, 
                                                      p_pay_cr_to_id   =>  v_p_pay_cr_to_id,
                                                      p_pay_ct_data_arr    =>  v_pay_ct_data);                                                       
   COMMIT;
   
   SELECT CREATE_DTIME_TECH, 
          UPDATE_DTIME_TECH
   INTO v_create_dtime_tech,
        v_update_dtime_tech
   FROM PAYMENT
   WHERE PAYMENT_ID = v_payment_id;
    
   IF v_create_dtime_tech <> v_update_dtime_tech THEN
      raise_application_error(-20501, 'Техническая Дата создания не равна технической дате обновления!');
   END IF;  
       
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
v_payment_id         PAYMENT.PAYMENT_ID%type := 33091106;
v_pay_table          payment_detail%ROWTYPE;
v_create_dtime_tech  PAYMENT.CREATE_DTIME_TECH%type;
v_update_dtime_tech  PAYMENT.UPDATE_DTIME_TECH%type;
v_pay_ct_data        t_payment_detail_array := t_payment_detail_array(t_payment_detail(81, 'WSXQAZ')
                                                                     );

BEGIN 
    payment_detail_api_pack.pr_insert_or_update_payment_detail(p_payment_id     =>  v_payment_id,
                                                               p_pay_data_arr  =>  v_pay_ct_data
                                                               );                                                                                           
   COMMIT;
   
   SELECT CREATE_DTIME_TECH, 
          UPDATE_DTIME_TECH
   INTO v_create_dtime_tech,
        v_update_dtime_tech
   FROM PAYMENT
   WHERE PAYMENT_ID = v_payment_id;
    
   IF v_create_dtime_tech = v_update_dtime_tech THEN
      raise_application_error(-20502, 'Техническая Дата создания равна технической дате обновления!');
   END IF;  
       
    
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

-- Негативные Unit-тесты --
-- Проверка "Создание платежа" f_create_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type;
v_pay_cr_sum      number(15,2) := 100000;
v_pay_cr_date     timestamp := systimestamp;
v_pay_cr_cur_id   integer := 643;
v_pay_cr_from_id  integer := 100;
v_p_pay_cr_to_id  integer := 999;
v_pay_ct_data     t_payment_detail_array := null;

BEGIN 
    v_payment_id := payment_api_pack.f_create_payment(p_pay_cr_sum       =>  v_pay_cr_sum, 
                                                      p_pay_cr_date      =>  v_pay_cr_date, 
                                                      p_pay_cr_cur_id    =>  v_pay_cr_cur_id,
                                                      p_pay_cr_from_id   =>  v_pay_cr_from_id, 
                                                      p_pay_cr_to_id     =>  v_p_pay_cr_to_id,
                                                      p_pay_ct_data_arr  =>  v_pay_ct_data);                                                       

  raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_empty_input_par  THEN
           dbms_output.put_line('В функции "Создание платежа". Ошибка: ' ||sqlerrm);   
END;
/

-- Проверка "Сброса платежа" pr_fail_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := null;
v_reset_reason    PAYMENT.STATUS_CHANGE_REASON%type := null;
BEGIN 
    payment_api_pack.pr_fail_payment(p_payment_id    =>  v_payment_id, 
                                     p_reset_reason  =>  v_reset_reason
                                     );                                                                                                                 
  
  raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');
  
  EXCEPTION  
      WHEN payment_common_pack.exp_empty_input_par  THEN
           dbms_output.put_line('В процедуре "Сброс платежа". Ошибка: ' ||sqlerrm);                      
                        
   
end;
/

-- Проверка "Отмены платежа" pr_cancel_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := null;
v_cancel_reason   PAYMENT.STATUS_CHANGE_REASON%type := null;

BEGIN 
    payment_api_pack.pr_cancel_payment(p_payment_id     =>  v_payment_id, 
                                       p_cancel_reason  =>  v_cancel_reason
                                       );                                                                                                 
   
  raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_empty_input_par  THEN
           dbms_output.put_line('В процедуре "Отмена платежа". Ошибка: ' ||sqlerrm);                      
                         
end;
/

-- Проверка "Завершения платежа" pr_successful_finish_payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := null;

BEGIN 
    payment_api_pack.pr_successful_finish_payment(p_payment_id   =>  v_payment_id);                                                                                           
     
                        
  raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_empty_input_par  THEN
           dbms_output.put_line('В процедуре "Завершение платежа". Ошибка: ' ||sqlerrm);                      
                                                 
end;
/

-- Проверка "Данных платежа" pr_insert_or_update_payment_detail --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := null;
v_pay_ct_data     t_payment_detail_array;

BEGIN 
    payment_detail_api_pack.pr_insert_or_update_payment_detail(p_payment_id    =>  v_payment_id,
                                                               p_pay_data_arr  =>  v_pay_ct_data
                                                               );                                                                                               
  
  raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_empty_input_par  THEN
           dbms_output.put_line('В процедуре "Данные платежа". Ошибка: ' ||sqlerrm);  
     
end;
/

-- Проверка "Детали платежа" delete_payment_detail --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := null;
v_pay_info_data   t_number_array;  

BEGIN 
    payment_detail_api_pack.delete_payment_detail(p_payment_id     =>  v_payment_id,
                                                  p_pay_info_data  =>  v_pay_info_data
                                                  );                                                                                                 
   
    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

    EXCEPTION  
      WHEN payment_common_pack.exp_empty_input_par  THEN
           dbms_output.put_line('В процедуре "Детали платежа". Ошибка: ' ||sqlerrm);  
          
end;
/

-- Проверка запрета удаления записи для триггера payment_b_d_restrict для таблицы payment --
DECLARE
v_payment_id      PAYMENT.PAYMENT_ID%type := 11; 

BEGIN 
    DELETE FROM PAYMENT WHERE v_payment_id = PAYMENT_ID;
    
    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_delete_obj  THEN
           dbms_output.put_line('Удаление записи. Ошибка: ' ||sqlerrm); 
END;
/

-- Проверка вставки данных не через API для таблицы payment --
DECLARE
v_payment_id         PAYMENT.PAYMENT_ID%type := 11;
v_pay_cr_sum         number(15,2) := 100000;
v_pay_cr_date        timestamp := systimestamp;
v_pay_cr_cur_id      integer := 643;
v_pay_cr_from_id     integer := 100;
v_p_pay_cr_to_id     integer := 999;


BEGIN 
    insert into payment(PAYMENT_ID, 
                        CREATE_DTIME, 
                        SUMMA,
                        CURRENCY_ID, 
                        FROM_CLIENT_ID, 
                        TO_CLIENT_ID)
    values (v_payment_id, 
            v_pay_cr_date, 
            v_pay_cr_sum, 
            v_pay_cr_cur_id,
            v_pay_cr_from_id,
            v_p_pay_cr_to_id
            ); 

    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_manual_changes  THEN
           dbms_output.put_line('Удаление записи. Ошибка: ' ||sqlerrm); 
END;
/

-- Проверка обновления данных не через API для таблицы payment --
DECLARE
v_payment_id         PAYMENT.PAYMENT_ID%type := 11;

BEGIN 
   update payment
   set payment_id = v_payment_id
   where payment_id = 11; 

    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_manual_changes  THEN
           dbms_output.put_line('Обнорвление записи. Ошибка: ' ||sqlerrm); 
END;
/

-- Проверка запрета удаления записи для триггера payment_detail_b_iud_api для таблицы payment_detail --
DECLARE
v_payment_id      payment_detail.PAYMENT_ID%type := 11; 

BEGIN 
    DELETE FROM payment_detail WHERE v_payment_id = PAYMENT_ID;
    
    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_delete_obj  THEN
           dbms_output.put_line('Удаление записи. Ошибка: ' ||sqlerrm); 
END;
/

-- Проверка вставки данных не через API для таблицы payment_detail --
DECLARE
v_payment_id         payment_detail.PAYMENT_ID%type := 11;

BEGIN 
    insert into payment_detail(PAYMENT_ID)
    values (v_payment_id
            ); 

    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_manual_changes  THEN
           dbms_output.put_line('Удаление записи. Ошибка: ' ||sqlerrm); 
END;
/

-- Проверка обновления данных не через API для таблицы payment_detail --
DECLARE
v_payment_id         payment_detail.PAYMENT_ID%type := 11;

BEGIN 
   update payment_detail
   set payment_id = v_payment_id
   where payment_id = 11; 

    raise_application_error(-20500, 'Unit-тест или API выполнены не верно!');

  EXCEPTION  
      WHEN payment_common_pack.exp_manual_changes  THEN
           dbms_output.put_line('Обнорвление записи. Ошибка: ' ||sqlerrm); 
END;
/

-- Unit-тесты на отключение глобального запрета -- 
-- 1.Прямой delete платежа --
DECLARE
v_payment_id       payment_detail.PAYMENT_ID%type := 11;

BEGIN
  payment_common_pack.pr_without_api_dml_enable();
  
  DELETE FROM payment 
  WHERE payment_id = v_payment_id;
  
  payment_common_pack.pr_without_api_dml_disable();
  
EXCEPTION 
  WHEN OTHERS THEN
    payment_common_pack.pr_without_api_dml_disable();
    RAISE;
END;
/

-- 2.Прямой update платежа --
DECLARE
  v_payment_id       payment_detail.PAYMENT_ID%type := 11;

BEGIN
  payment_common_pack.pr_without_api_dml_enable();
  
  UPDATE payment 
  SET PAYMENT_ID = 111 
  WHERE payment_id = v_payment_id;
  
  payment_common_pack.pr_without_api_dml_disable();
  
EXCEPTION 
  WHEN OTHERS THEN
    payment_common_pack.pr_without_api_dml_disable();
    RAISE;
END;
/

-- 3.Прямой update деталей платежа --
DECLARE
  v_payment_id       payment_detail.PAYMENT_ID%type := 11;

BEGIN
  payment_common_pack.pr_without_api_dml_enable();
  
  UPDATE payment_detail 
  SET PAYMENT_ID = 111 
  WHERE payment_id = v_payment_id;
  
  payment_common_pack.pr_without_api_dml_disable();
  
EXCEPTION 
  WHEN OTHERS THEN
    payment_common_pack.pr_without_api_dml_disable();
    RAISE;
END;
/
