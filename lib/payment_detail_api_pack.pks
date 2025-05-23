Create or replace package payment_detail_api_pack  is 
/*
Автор: ФИО
Описание скрипта: API для сущностей “Детали платежа” 
*/
    -- Сообщения ошибок --   
    c_error_msg_empty_id       constant varchar2(250 char) := 'ID Поля не может быть пустым!';
    c_error_msg_empty_val      constant varchar2(250 char) := 'Значение в поле не может быть пустым!';
    c_error_msg_empty_coll     constant varchar2(250 char) := 'Коллекция не содержит данных!';
    c_error_msg_empty_reason   constant varchar2(250 char) := 'Причина не может быть пустой!';
    c_error_msg_empty_obj_id   constant varchar2(250 char) := 'ID объекта не может быть пустым!';

 
    -- Данные платежа --
    procedure pr_insert_or_update_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                                 p_pay_data_data  t_payment_detail_array);

    -- Детали платежа --
    procedure delete_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                    p_pay_info_data  t_number_array);
end;
/