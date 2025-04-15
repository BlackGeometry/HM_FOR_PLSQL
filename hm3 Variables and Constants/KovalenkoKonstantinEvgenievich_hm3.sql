/*
Автор: ФИО
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/
-- Создание платежа --
declare 
   v_message   varchar2(50) := 'Платеж создан';
   c_status    constant number := 0;
begin 
dbms_output.put_line(v_message ||'. Статус: '|| c_status);
end;
/
-- Сброс платежа --
declare 
   v_message   varchar2(50) := 'Сброс платежа';
   c_status    constant number := 2;
   v_reason    varchar2(50) := 'недостаточно средств'; 
begin 
dbms_output.put_line(v_message ||' в "ошибочный статус" с указанием причины. Статус: '|| c_status ||'. Причина: '|| v_reason);
end;
/
-- Отмена платежа --
declare 
   v_message   varchar2(50) := 'Отмена платежа';
   c_status    constant number := 3;
   v_reason    varchar2(50) := 'ошибка пользователя';
begin 
dbms_output.put_line(v_message ||' с указанием причины. Статус: '|| c_status ||'. Причина: '|| v_reason);
end;
/
-- Завершение платежа --
declare 
   v_message   varchar2(100) := 'Успешное завершение платежа';
   c_status    constant number := 1;
begin 
dbms_output.put_line(v_message ||'. Статус: '|| c_status);
end;
/
-- Данные платежа --
declare 
   v_message   varchar2(200) := 'добавлены или обновлены по списку id_поля/значение';
begin  
dbms_output.put_line('Данные платежа '|| v_message);
end;
/
-- Детали платежа --
declare 
   v_message   varchar2(200) := 'удалены по списку id_полей';
begin  
dbms_output.put_line('Детали платежа '|| v_message);
end;
/