/*
Автор: ФИО
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа --
declare 
   v_message         varchar2(500 char) := 'Платеж создан';
   c_pay_cr_status   constant PAYMENT.STATUS%type := 0;
   v_pay_cr_date     timestamp := systimestamp; 
   v_payment_id      PAYMENT.PAYMENT_ID%type := 0;
   v_pay_ct_data     t_payment_detail_array := t_payment_detail_array(
                                                                      t_payment_detail(1, 'SBER'),
                                                                      t_payment_detail(2, '192.168.100.10'),
                                                                      t_payment_detail(3, 'Шаблон'),
                                                                      t_payment_detail(4, 'Да')
                                                                      );
begin 
dbms_output.put_line(v_message ||'. Статус: '|| c_pay_cr_status || '. ID: '|| v_payment_id);
dbms_output.put_line(to_char(v_pay_cr_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/

-- Сброс платежа --
declare 
   v_message         varchar2(500 char) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
   c_reset_status    constant PAYMENT.STATUS%type := 2;
   v_reset_reason    PAYMENT.STATUS_CHANGE_REASON%type := 'недостаточно средств'; 
   v_reset_date      timestamp := systimestamp;  
   v_payment_id      PAYMENT.PAYMENT_ID%type := 0;

begin 

 if v_reset_reason is null then 
    dbms_output.put_line('Причина не может быть пустой!');
 end if; 
 
 if v_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if; 

dbms_output.put_line(v_message ||' Статус: '|| c_reset_status ||'. Причина: '|| v_reset_reason || '. ID: '|| v_payment_id);
dbms_output.put_line(to_char(v_reset_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/

-- Отмена платежа --
declare 
   v_message         varchar2(500 char) := 'Отмена платежа с указанием причины.';
   c_cancel_status   constant PAYMENT.STATUS%type := 3;
   v_cancel_reason   PAYMENT.STATUS_CHANGE_REASON%type := 'ошибка пользователя';
   v_cancel_date     timestamp := systimestamp;  
   v_payment_id      PAYMENT.PAYMENT_ID%type := 0;
 
begin 
  
 if v_cancel_reason is null then 
    dbms_output.put_line('Причина не может быть пустой!');
 end if; 

 if v_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if; 

dbms_output.put_line(v_message ||' Статус: '|| c_cancel_status ||'. Причина: '|| v_cancel_reason || '. ID: '|| v_payment_id);
dbms_output.put_line(to_char(v_cancel_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/ 

-- Завершение платежа --
declare 
   v_message         varchar2(500 char) := 'Успешное завершение платежа';
   c_complet_status  constant PAYMENT.STATUS%type := 1;
   v_complet_date    timestamp := sysdate;  
   v_payment_id      PAYMENT.PAYMENT_ID%type := 0;

begin 
  
 if v_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if;

dbms_output.put_line(v_message ||'. Статус: '|| c_complet_status || '. ID: '|| v_payment_id);
dbms_output.put_line(to_char(v_complet_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/

-- Данные платежа --
declare 
   v_message        varchar2(500 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
   v_pay_data_date  timestamp := TO_TIMESTAMP('01.01.2500 00:00:00', 'DD.MM.YYYY HH24:MI:SS', 'NLS_DATE_LANGUAGE=RUSSIAN'); 
   v_payment_id     PAYMENT.PAYMENT_ID%type := 0;
   v_pay_data_data  t_payment_detail_array := t_payment_detail_array(            
                                                                     t_payment_detail(3, 'Обновлено!')
                                                                     );
begin  
  
 if v_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if;

dbms_output.put_line(v_message || '. ID: '|| v_payment_id);
dbms_output.put_line(to_char(v_pay_data_date, 'dd.mm.yyyy HH24:MI:SS.FF', 'NLS_DATE_LANGUAGE=RUSSIAN'));
end;
/

-- Детали платежа --
declare 
   v_message         varchar2(500 char) := 'Детали платежа удалены по списку id_полей';  
   v_pay_info_time   date := sysdate;
   v_pay_info_month  varchar2(50);  
   v_pay_info_year   varchar2(50);
   v_payment_id      PAYMENT.PAYMENT_ID%type := 0;
   v_pay_info_data   t_number_array := t_number_array(1,2,3);

begin 
    
   v_pay_info_month := to_char(v_pay_info_time, 'FMMonth DD');
   v_pay_info_year  := to_char(v_pay_info_time, 'YYYY');
   
 if v_payment_id is null then 
    dbms_output.put_line('ID объекта не может быть пустым!');
 end if;
   
dbms_output.put_line(v_message);
dbms_output.put_line('Месяц платежа '|| v_pay_info_month ||', год платежа '|| v_pay_info_year || '. ID: '|| v_payment_id);

end;
/
