create or replace package payment_common_pack  is
/*
Автор: Kovalenko K.E.
Описание скрипта: Константы для сущностей - "Платеж", "Детали платежа".
*/
    -- Константы статусов активности клиена --
    c_pay_cr_status   constant PAYMENT.STATUS%type := 0;
    c_complet_status  constant PAYMENT.STATUS%type := 1;
    c_reset_status    constant PAYMENT.STATUS%type := 2;
    c_cancel_status   constant PAYMENT.STATUS%type := 3;

    -- Сообщения ошибок --
    c_error_msg_empty_id               constant varchar2(250 char) := 'ID Поля не может быть пустым!';
    c_error_msg_empty_val              constant varchar2(250 char) := 'Значение в поле не может быть пустым!';
    c_error_msg_empty_coll             constant varchar2(250 char) := 'Коллекция не содержит данных!';
    c_error_msg_empty_reason           constant varchar2(250 char) := 'Причина не может быть пустой!';
    c_error_msg_empty_obj_id           constant varchar2(250 char) := 'ID объекта не может быть пустым!';
    c_error_msg_delete_obj             constant varchar2(250 char) := 'Удаление объекта запрещено!';
    c_error_msg_dml_changes            constant varchar2(250 char) := 'Изменения доступны только через API!';
    c_error_msg_inactive_object        constant varchar2(250 char) := 'Объект в конечном статусе. Изменения невозможны!';
    c_error_msg_object_notfound        constant varchar2(250 char) := 'Объект не найден!';
    c_error_msg_object_already_locked  constant varchar2(250 char) := 'Объект уже заблокирован!';


    -- Коды ошибкок --
    c_error_code_empty_par              constant number(10) := -20099;
    c_error_code_delete_obj             constant number(10) := -20098;
    c_error_code_dml_changes            constant number(10) := -20097;
    c_error_code_dml_inactive_object    constant number(10) := -20104;
    c_error_code_object_notfound        constant number(10) := -20105;
    c_error_code_object_already_locked  constant number(10) := -20106;

    -- Объекты исключений -- 
    exp_empty_input_par exception;
    pragma exception_init(exp_empty_input_par, c_error_code_empty_par);
    exp_delete_obj exception;
    pragma exception_init(exp_delete_obj, c_error_code_delete_obj);
    exp_manual_changes exception;
    pragma exception_init(exp_manual_changes, c_error_code_dml_changes);
    exp_inactive_object exception;
    pragma exception_init(exp_inactive_object, c_error_code_dml_inactive_object);
    exp_object_notfound exception;
    pragma exception_init(exp_object_notfound, c_error_code_object_notfound);
    exp_row_locked exception;
    pragma exception_init(exp_row_locked, -00054);
    exp_object_already_locked exception;
    pragma exception_init(exp_object_already_locked, c_error_code_object_already_locked);

    -- Процедура вклюения DML в обход API --
    procedure pr_without_api_dml_enable;

    -- Процедура отключения DML в обход API --
    procedure pr_without_api_dml_disable;

    -- Функция получения текущего статуса режима работы изменения DML в API --
    function f_dml_api_check return boolean;

end payment_common_pack;
/