/*
Автор: ФИО
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа --
declare 
   v_mess_create       varchar2(50) := 'Платеж создан';
   c_status_create_0   constant number := 0;
begin 
dbms_output.put_line(v_mess_create ||'. Статус: '|| c_status_create_0);
end;
/
-- Сброс платежа --
declare 
   v_mess_reset      varchar2(50) := 'Сброс платежа';
   c_status_reset_2  constant number := 2;
   v_reason_reset_insuffi  varchar2(50) := 'недостаточно средств'; 
begin 
dbms_output.put_line(v_mess_reset ||' в "ошибочный статус" с указанием причины. Статус: '|| c_status_reset_2 ||'. Причина: '|| v_reason_reset_insuffi);
end;
/
-- Отмена платежа --
declare 
   v_mess_cancel              varchar2(50) := 'Отмена платежа';
   c_status_cancel_3          constant number := 3;
   v_reason_cancel_user_miss  varchar2(50) := 'ошибка пользователя';
begin 
dbms_output.put_line(v_mess_cancel ||' с указанием причины. Статус: '|| c_status_cancel_3 ||'. Причина: '|| v_reason_cancel_user_miss);
end;
/
-- Завершение платежа --
declare 
   v_mess_complet      varchar2(100) := 'Успешное завершение платежа';
   c_status_complet_1  constant number := 1;
begin 
dbms_output.put_line(v_mess_complet ||'. Статус: '|| c_status_complet_1);
end;
/
-- Данные платежа --
declare 
   v_mess_info   varchar2(200) := 'добавлены или обновлены по списку id_поля/значение';
begin  
dbms_output.put_line('Данные платежа '|| v_mess_info);
end;
/
-- Детали платежа --
declare 
   v_mess_delete   varchar2(200) := 'удалены по списку id_полей';
begin  
dbms_output.put_line('Детали платежа '|| v_mess_delete);
end;
/