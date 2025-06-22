create or replace package body payment_detail_api_pack is
  /*
  Автор: Kovalenko K.E.
  Описание скрипта: API для сущностей “Детали платежа”
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
  
  -- Данные платежа --
  procedure pr_insert_or_update_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                               p_pay_data_arr   t_payment_detail_array)
  as 
  begin  

   if p_payment_id is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_obj_id);
   end if;
   
   api_chages_enable();
   
   merge into payment_detail pd
   using (select p_payment_id as payment_id,
                 systimestamp as payment_create_dtime, 
                 value(t).field_id as field_id,
                 value(t).field_value as field_value
          from table (p_pay_data_arr) t) arr 
   on (pd.payment_id = arr.payment_id
       and 
       pd.field_id = arr.field_id)
   when matched then
      update set pd.field_value = arr.field_value
   when not matched then
      insert (pd.payment_id,
              pd.payment_create_dtime,
              pd.field_id,
              pd.field_value)
      values  (arr.payment_id,
               arr.payment_create_dtime,
               arr.field_id,
               arr.field_value);
  
   api_chages_disable();
         
   exception 
      when others then 
          api_chages_disable();
      raise;
  
end pr_insert_or_update_payment_detail;

  -- Детали платежа --
  procedure delete_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                  p_pay_info_data  t_number_array)
  as 
  begin 
     
   if p_payment_id is null then 
      raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_obj_id);
   end if;

   if p_pay_info_data is empty then
       raise_application_error(payment_common_pack.c_error_code_empty_par, payment_common_pack.c_error_msg_empty_coll);
   end if;  
   
   api_chages_enable();
   
   delete from payment_detail pd
   where pd.payment_id = p_payment_id
         and 
         pd.field_id in (select value(t) as field_id
                         from table(p_pay_info_data) t );  
  api_chages_disable();
         
   exception 
      when others then 
          api_chages_disable();
      raise;
  
  end delete_payment_detail;
  
  -- Проверка DML через API --
  procedure pr_dml_api_check
  as    
  begin 
     if not g_api_flag and not payment_common_pack.f_dml_api_check() then
          raise_application_error(payment_common_pack.c_error_code_dml_changes, payment_common_pack.c_error_msg_dml_changes); 
     end if;
  end pr_dml_api_check;
  
  
end payment_detail_api_pack;
/
