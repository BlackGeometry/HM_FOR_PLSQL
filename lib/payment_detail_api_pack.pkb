create or replace package body payment_detail_api_pack is
  /*
  Автор: Kovalenko K.E.
  Описание скрипта: API для сущностей “Детали платежа”
  */

  -- Данные платежа --
  procedure pr_insert_or_update_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                               p_pay_data_data  t_payment_detail_array)
  as 
     v_message        varchar2(500 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
     v_pay_data_date  timestamp := TO_TIMESTAMP('01.01.2500 00:00:00', 'DD.MM.YYYY HH24:MI:SS', 'NLS_DATE_LANGUAGE=RUSSIAN'); 
     v_payment_id     PAYMENT.PAYMENT_ID%type := 0;

  begin  
    
    if p_pay_data_data is not empty then
      
       for i in p_pay_data_data.first..p_pay_data_data.last loop
         
         if p_pay_data_data(i).field_id is null then
            raise_application_error(c_error_code_empty_par, c_error_msg_empty_id);
         end if;
            
         if p_pay_data_data(i).field_value is null then
            raise_application_error(c_error_code_empty_par, c_error_msg_empty_val);   
         end if;
      
         dbms_output.put_line('Field_id: '||p_pay_data_data(i).field_id ||'. Field_value: '|| p_pay_data_data(i).field_value);
       end loop;  
    else 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_coll);
    end if;  

   if p_payment_id is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_obj_id);
   end if;
   
   merge into payment_detail pd
   using (select p_payment_id as payment_id,
                 systimestamp as payment_create_dtime, 
                 value(t).field_id as field_id,
                 value(t).field_value as field_value
          from table (p_pay_data_data) t) arr 
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

  dbms_output.put_line(v_message || '. ID: '|| p_payment_id);
  dbms_output.put_line(to_char(v_pay_data_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN')); 
end pr_insert_or_update_payment_detail;

  -- Детали платежа --
  procedure delete_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                  p_pay_info_data  t_number_array)
  as 
     v_message         varchar2(500 char) := 'Детали платежа удалены по списку id_полей';  
     v_pay_info_time   date := sysdate;
     v_pay_info_month  varchar2(50);  
     v_pay_info_year   varchar2(50);
     v_payment_id      PAYMENT.PAYMENT_ID%type := 0;

  begin 
      
     v_pay_info_month := to_char(v_pay_info_time, 'FMMonth DD');
     v_pay_info_year  := to_char(v_pay_info_time, 'YYYY');
     
   if p_payment_id is null then 
      raise_application_error(c_error_code_empty_par, c_error_msg_empty_obj_id);
   end if;
     
  dbms_output.put_line(v_message);
  dbms_output.put_line('Месяц платежа '|| v_pay_info_month ||', год платежа '|| v_pay_info_year || '. ID: '|| p_payment_id);


   if p_pay_info_data is empty then
       raise_application_error(c_error_code_empty_par, c_error_msg_empty_coll);
   end if;  
   
   delete from payment_detail pd
   where pd.payment_id = p_payment_id
         and 
         pd.field_id in (select value(t) as field_id
                         from table(p_pay_info_data) t );

  dbms_output.put_line('Количество полей для удаления: '|| p_pay_info_data.count());
  end delete_payment_detail;
  
end payment_detail_api_pack;
/