create or replace package body payment_api_pack is
/*
Автор: Kovalenko K.E.
Описание скрипта: API для сущностей “Платеж”
*/
  
  -- Признак выполнения API --
  g_api_flag boolean := false;
  
  procedure api_chages_enable as
    begin 
      g_api_flag := true;
    end;  
  
  procedure api_chages_disable as
    begin 
      g_api_flag := false;
    end;  
    
  -- Создание платежа --
  function f_create_payment(p_pay_cr_sum       PAYMENT.SUMMA%type,
                            p_pay_cr_date      PAYMENT.CREATE_DTIME%type,
                            p_pay_cr_cur_id    PAYMENT.CURRENCY_ID%type,
                            p_pay_cr_from_id   PAYMENT.FROM_CLIENT_ID%type, 
                            p_pay_cr_to_id     PAYMENT.TO_CLIENT_ID%type,
                            p_pay_ct_data_arr  t_payment_detail_array) return payment_detail.PAYMENT_ID%type
  as
     v_message         varchar2(500 char) := 'Платеж создан'; 
     v_pay_cr_date     timestamp := systimestamp; 
     v_payment_id      PAYMENT.PAYMENT_ID%type := 0;
                                                                   
  begin 
    
    if p_pay_ct_data_arr is not empty then
      
       for i in p_pay_ct_data_arr.first..p_pay_ct_data_arr.last loop
         
         if p_pay_ct_data_arr(i).field_id is null then
            raise_application_error(c_error_code_empty_par, c_error_msg_empty_id);
         end if;
            
         if p_pay_ct_data_arr(i).field_value is null then
            raise_application_error(c_error_code_empty_par, c_error_msg_empty_val);   
         end if;
      
         dbms_output.put_line('Field_id: '||p_pay_ct_data_arr(i).field_id ||'. Field_value: '|| p_pay_ct_data_arr(i).field_value);
       end loop;  
    else 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_coll); 
    end if;  

    api_chages_enable();
   
   --Заполнение payment--
    insert into payment(PAYMENT_ID, 
                        CREATE_DTIME, 
                        SUMMA,
                        CURRENCY_ID, 
                        FROM_CLIENT_ID, 
                        TO_CLIENT_ID)
    values (payment_seq.nextval, 
            p_pay_cr_date, 
            p_pay_cr_sum, 
            p_pay_cr_cur_id,
            p_pay_cr_from_id, 
            p_pay_cr_to_id) 
    returning payment_id 
    into v_payment_id;
    commit;

    --Заполнение payment_detail--
    payment_detail_api_pack.pr_insert_or_update_payment_detail(p_payment_id    => v_payment_id,  
                                                               p_pay_data_arr  => p_pay_ct_data_arr);    
    api_chages_disable();
    
    return v_payment_id;
    
    exception 
      when others then 
          api_chages_disable();
      raise;    
      
  end f_create_payment;

  -- Сброс платежа -- 
  procedure pr_fail_payment(p_payment_id    PAYMENT.PAYMENT_ID%type,
                            p_reset_reason  PAYMENT.STATUS_CHANGE_REASON%type) 
  as
     v_message         varchar2(500 char) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
     v_reset_date      timestamp := systimestamp;  


  begin 

   if p_reset_reason is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_reason);
   end if; 
   
   if p_payment_id is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_obj_id);
   end if; 
   
   api_chages_enable();
   
   update payment
   set status = c_reset_status,
       status_change_reason = p_reset_reason
   where payment_id = p_payment_id 
         and 
         status = 0; 
         
   dbms_output.put_line(v_message ||' Статус: '|| c_reset_status ||'. Причина: '|| p_reset_reason || '. ID: '|| p_payment_id);
   dbms_output.put_line(to_char(v_reset_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
   
   api_chages_disable();
         
   exception 
      when others then 
          api_chages_disable();
      raise;  
            
  end pr_fail_payment;

  -- Отмена платежа --
  procedure pr_cancel_payment(p_payment_id     PAYMENT.PAYMENT_ID%type,
                              p_cancel_reason  PAYMENT.STATUS_CHANGE_REASON%type) 
  as 
     v_message         varchar2(500 char) := 'Отмена платежа с указанием причины.';
     v_cancel_date     timestamp := systimestamp;  
   
  begin 
    
   if p_cancel_reason is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_reason);
   end if; 

   if p_payment_id is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_obj_id);
   end if; 
   
   api_chages_enable();
   
   update payment
   set status = c_cancel_status,
       status_change_reason = p_cancel_reason
   where payment_id = p_payment_id 
         and 
         status = 0; 

  dbms_output.put_line(v_message ||' Статус: '|| c_cancel_status ||'. Причина: '|| p_cancel_reason || '. ID: '|| p_payment_id);
  dbms_output.put_line(to_char(v_cancel_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
  
  api_chages_disable();
         
   exception 
      when others then 
          api_chages_disable();
      raise;  
  
  end pr_cancel_payment;

  -- Завершение платежа --
  procedure pr_successful_finish_payment(p_payment_id PAYMENT.PAYMENT_ID%type)
  as 
     v_message         varchar2(500 char) := 'Успешное завершение платежа';
     v_complet_date    timestamp := sysdate;  
  begin 
    
   if p_payment_id is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_obj_id);
   end if;
   
   api_chages_enable();
   
   update payment
   set status = c_complet_status,
       status_change_reason = null
   where payment_id = p_payment_id 
         and 
         status = 0;

  dbms_output.put_line(v_message ||'. Статус: '|| c_complet_status || '. ID: '|| p_payment_id);
  dbms_output.put_line(to_char(v_complet_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
  
  api_chages_disable();
         
   exception 
      when others then 
          api_chages_disable();
      raise;
  
  end pr_successful_finish_payment;
  
  -- Проверка DML через API --
  procedure pr_dml_api_check
  as    
  begin 
     if not g_api_flag then
          raise_application_error(c_error_code_dml_changes, c_error_msg_dml_changes); 
     end if;
  end pr_dml_api_check;
   
end payment_api_pack;     
/