/*
Автор: ФИО
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа --
declare 
   v_message        varchar2(500) := 'Платеж создан';
   c_status_pay_cr  constant number := 0;
begin 
dbms_output.put_line(v_message ||'. Статус: '|| c_status_pay_cr);
end;
/
-- Сброс платежа --
declare 
   v_message               varchar2(500) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
   c_status_reset  		   constant number := 2;
   v_reason_reset_insuffi  varchar2(250) := 'недостаточно средств'; 
begin 
dbms_output.put_line(v_message ||' Статус: '|| c_status_reset ||'. Причина: '|| v_reason_reset_insuffi);
end;
/
-- Отмена платежа --
declare 
   v_message             varchar2(500) := 'Отмена платежа с указанием причины.';
   c_status_cancel       constant number := 3;
   v_reason_cancel_miss  varchar2(250) := 'ошибка пользователя';
begin 
dbms_output.put_line(v_message ||' Статус: '|| c_status_cancel ||'. Причина: '|| v_reason_cancel_miss);
end;
/ 
-- Завершение платежа --
declare 
   v_message         varchar2(500) := 'Успешное завершение платежа';
   c_status_complet  constant number := 1;
begin 
dbms_output.put_line(v_message ||'. Статус: '|| c_status_complet);
end;
/
-- Данные платежа --
declare 
   v_message  varchar2(500) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
begin  
dbms_output.put_line(v_message);
end;
/
-- Детали платежа --
declare 
   v_message varchar2(500) := 'Детали платежа удалены по списку id_полей';
begin  
dbms_output.put_line(v_message);
end;
/