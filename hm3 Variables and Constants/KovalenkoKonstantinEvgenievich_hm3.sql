/*
Автор: ФИО
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа --
declare 
   v_message        varchar2(500) := 'Платеж создан';
   c_pay_cr_status  constant number := 0;
begin 
dbms_output.put_line(v_message ||'. Статус: '|| c_pay_cr_status);
end;
/
-- Сброс платежа --
declare 
   v_message          varchar2(500) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
   c_reset_status     constant number := 2;
   v_reset_reason     varchar2(250) := 'недостаточно средств'; 
begin 
dbms_output.put_line(v_message ||' Статус: '|| c_status_reset ||'. Причина: '|| v_reset_reason);
end;
/
-- Отмена платежа --
declare 
   v_message          varchar2(500) := 'Отмена платежа с указанием причины.';
   c_cancel_status    constant number := 3;
   v_cancel_reason    varchar2(250) := 'ошибка пользователя';
begin 
dbms_output.put_line(v_message ||' Статус: '|| c_status_cancel ||'. Причина: '|| v_cancel_reason);
end;
/ 
-- Завершение платежа --
declare 
   v_message         varchar2(500) := 'Успешное завершение платежа';
   c_complet_status  constant number := 1;
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
