/*
Автор: ФИО
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

-- Создание платежа --

create or replace function f_create_payment(p_pay_cr_sum     PAYMENT.SUMMA%type, 
                                            p_pay_cr_cur_id  PAYMENT.CURRENCY_ID%type,
                                            p_pay_cr_from_id PAYMENT.FROM_CLIENT_ID%type, 
                                            p_pay_cr_to_id   PAYMENT.TO_CLIENT_ID%type,
                                            p_pay_ct_data    t_payment_detail_array) return payment_detail.PAYMENT_ID%type
as
   v_message         varchar2(500 char) := 'Платеж создан'; 
   c_pay_cr_status   constant PAYMENT.STATUS%type := 0;
   v_pay_cr_date     timestamp := systimestamp; 
   v_payment_id      PAYMENT.PAYMENT_ID%type := 0;
                                                                 
begin 
  
  if p_pay_ct_data is not empty then
    
     for i in p_pay_ct_data.first..p_pay_ct_data.last loop
       
       if p_pay_ct_data(i).field_id is null then
          dbms_output.put_line('ID Поля не может быть пустым!');
       end if;
          
       if p_pay_ct_data(i).field_value is null then
          dbms_output.put_line('Значение в поле не может быть пустым!');   
       end if;
    
       dbms_output.put_line('Field_id: '||p_pay_ct_data(i).field_id ||'. Field_value: '|| p_pay_ct_data(i).field_value);
     end loop;  
  else 
    dbms_output.put_line('Коллекция не содержит данных!');
  end if;  

   --Заполнение payment--
  insert into payment(PAYMENT_ID, 
                      CREATE_DTIME, 
                      SUMMA,
                      CURRENCY_ID, 
                      FROM_CLIENT_ID, 
                      TO_CLIENT_ID)
  values (payment_seq.nextval, 
          systimestamp, 
          p_pay_cr_sum, 
          p_pay_cr_cur_id,
          p_pay_cr_from_id, 
          p_pay_cr_to_id) 
  returning payment_id 
  into v_payment_id;
  commit;

  --Заполнение payment_detail--
  insert into payment_detail(PAYMENT_ID, 
                             PAYMENT_CREATE_DTIME, 
                             FIELD_ID, 
                             FIELD_VALUE)
  select v_payment_id, 
         systimestamp, 
         value(t).FIELD_ID, 
         value(t).field_value 
  from table(p_pay_ct_data)t; 
  commit;
  
dbms_output.put_line(v_message ||'. Статус: '|| c_pay_cr_status || '. ID: '|| v_payment_id);
dbms_output.put_line(to_char(v_pay_cr_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));

     return v_payment_id;

end;
/
-- Сброс платежа -- 
create or replace procedure pr_fail_payment(p_payment_id    PAYMENT.PAYMENT_ID%type,
                                            p_reset_reason  PAYMENT.STATUS_CHANGE_REASON%type) 
as
   v_message         varchar2(500 char) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
   c_reset_status    constant PAYMENT.STATUS%type := 2;
   v_reset_date      timestamp := systimestamp;  


begin 

 if p_reset_reason is null then 
    dbms_output.put_line('Причина не может быть пустой!');
 end if; 
 
 if p_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if; 
 
 update payment
 set status = c_reset_status,
     status_change_reason = p_reset_reason
 where payment_id = p_payment_id 
       and 
       status = 0; 

dbms_output.put_line(v_message ||' Статус: '|| c_reset_status ||'. Причина: '|| p_reset_reason || '. ID: '|| p_payment_id);
dbms_output.put_line(to_char(v_reset_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/

-- Отмена платежа --
create or replace procedure pr_cancel_payment(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                              p_cancel_reason  PAYMENT.STATUS_CHANGE_REASON%type) 
as 
   v_message         varchar2(500 char) := 'Отмена платежа с указанием причины.';
   c_cancel_status   constant PAYMENT.STATUS%type := 3;
   v_cancel_date     timestamp := systimestamp;  
 
begin 
  
 if p_cancel_reason is null then 
    dbms_output.put_line('Причина не может быть пустой!');
 end if; 

 if p_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if; 
 
 update payment
 set status = c_cancel_status,
     status_change_reason = p_cancel_reason
 where payment_id = p_payment_id 
       and 
       status = 0; 

dbms_output.put_line(v_message ||' Статус: '|| c_cancel_status ||'. Причина: '|| p_cancel_reason || '. ID: '|| p_payment_id);
dbms_output.put_line(to_char(v_cancel_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/ 

-- Завершение платежа --
create or replace procedure pr_successful_finish_payment(p_payment_id PAYMENT.PAYMENT_ID%type)
as 
   v_message         varchar2(500 char) := 'Успешное завершение платежа';
   c_complet_status  constant PAYMENT.STATUS%type := 1;
   v_complet_date    timestamp := sysdate;  
begin 
  
 if p_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if;
 
 update payment
 set status = c_complet_status,
     status_change_reason = null
 where payment_id = p_payment_id 
       and 
       status = 0;

dbms_output.put_line(v_message ||'. Статус: '|| c_complet_status || '. ID: '|| p_payment_id);
dbms_output.put_line(to_char(v_complet_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/

-- Данные платежа --
create or replace procedure pr_insert_or_update_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                                               p_pay_data_data  t_payment_detail_array)
as 
   v_message        varchar2(500 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
   v_pay_data_date  timestamp := TO_TIMESTAMP('01.01.2500 00:00:00', 'DD.MM.YYYY HH24:MI:SS', 'NLS_DATE_LANGUAGE=RUSSIAN'); 
   v_payment_id     PAYMENT.PAYMENT_ID%type := 0;

begin  
  
  if p_pay_data_data is not empty then
    
     for i in p_pay_data_data.first..p_pay_data_data.last loop
       
       if p_pay_data_data(i).field_id is null then
          dbms_output.put_line('ID Поля не может быть пустым!');
       end if;
          
       if p_pay_data_data(i).field_value is null then
          dbms_output.put_line('Значение в поле не может быть пустым!');   
       end if;
    
       dbms_output.put_line('Field_id: '||p_pay_data_data(i).field_id ||'. Field_value: '|| p_pay_data_data(i).field_value);
     end loop;  
  else 
    dbms_output.put_line('Коллекция не содержит данных!');
  end if;  

 if p_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
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
end;
/

-- Детали платежа --
create or replace procedure delete_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
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
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if;
   
dbms_output.put_line(v_message);
dbms_output.put_line('Месяц платежа '|| v_pay_info_month ||', год платежа '|| v_pay_info_year || '. ID: '|| p_payment_id);


 if p_pay_info_data is empty then
     dbms_output.put_line('Коллекция не содержит данных!');
 end if;  
 
 delete from payment_detail pd
 where pd.payment_id = p_payment_id
       and 
       pd.field_id in (select value(t) as field_id
                       from table(p_pay_info_data) t );

dbms_output.put_line('Количество полей для удаления: '|| p_pay_info_data.count());

end;
/
