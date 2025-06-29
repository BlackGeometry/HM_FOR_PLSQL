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
     v_payment_id      PAYMENT.PAYMENT_ID%type := 0;
                                                                   
  begin
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
  begin 

   if p_reset_reason is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_reason);
   end if; 
   
   if p_payment_id is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_obj_id);
   end if; 
   
   try_lock_payment(p_payment_id);
   
   api_chages_enable();
   
   update payment
   set status = payment_common_pack.c_reset_status,
       status_change_reason = p_reset_reason
   where payment_id = p_payment_id 
         and 
         status = 0; 
  
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
  begin 
    
   if p_cancel_reason is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_reason);
   end if; 

   if p_payment_id is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_obj_id);
   end if; 
   
   try_lock_payment(p_payment_id);
   
   api_chages_enable();
   
   update payment
   set status = payment_common_pack.c_cancel_status,
       status_change_reason = p_cancel_reason
   where payment_id = p_payment_id 
         and 
         status = 0; 

  api_chages_disable();
         
   exception 
      when others then 
          api_chages_disable();
      raise;  
  
  end pr_cancel_payment;

  -- Завершение платежа --
  procedure pr_successful_finish_payment(p_payment_id PAYMENT.PAYMENT_ID%type)
  as 
  begin 
    
   if p_payment_id is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_obj_id);
   end if;
   
   try_lock_payment(p_payment_id);
  
   api_chages_enable();
   
   update payment
   set status = payment_common_pack.c_complet_status,
       status_change_reason = null
   where payment_id = p_payment_id 
         and 
         status = 0;

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
     if not g_api_flag and not payment_common_pack.f_dml_api_check() then
          raise_application_error(payment_common_pack.c_error_code_dml_changes, payment_common_pack.c_error_msg_dml_changes); 
     end if;
  end pr_dml_api_check;
   
  -- Проверка DML не через API --
  procedure pr_without_api_dml_check  
  as
  begin
    if not payment_common_pack.f_dml_api_check() then
      raise_application_error(payment_common_pack.c_error_code_dml_changes, payment_common_pack.c_error_msg_dml_changes);
    end if;
  end pr_without_api_dml_check;
  
  -- Блокировка по платежу -- 
  procedure try_lock_payment(p_payment_id PAYMENT.PAYMENT_ID%type)
  as 
    v_status_check      PAYMENT.STATUS%type;
  begin
    select t.STATUS 
    into v_status_check 
    from payment t 
    where t.payment_id = p_payment_id
    for update nowait;
    
    if v_status_check <> payment_common_pack.c_pay_cr_status then
          raise_application_error(payment_common_pack.c_error_code_dml_inactive_object, payment_common_pack.c_error_msg_inactive_object);
    end if;
      exception
          when no_data_found then
             raise_application_error(payment_common_pack.c_error_code_object_notfound, payment_common_pack.c_error_msg_object_notfound);
          when payment_common_pack.exp_row_locked then
             raise_application_error(payment_common_pack.c_error_code_object_already_locked, payment_common_pack.c_error_msg_object_already_locked);            
  end try_lock_payment;
  
end payment_api_pack;     
/
