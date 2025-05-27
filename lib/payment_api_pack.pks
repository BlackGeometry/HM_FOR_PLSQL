Create or replace package payment_api_pack is 
/*
Автор: Kovalenko K.E.
Описание скрипта: API для сущностей “Платеж” 
*/
    -- Константы статусов активности клиена -- 
    c_pay_cr_status   constant PAYMENT.STATUS%type := 0;
    c_complet_status  constant PAYMENT.STATUS%type := 1;
    c_reset_status    constant PAYMENT.STATUS%type := 2;
    c_cancel_status   constant PAYMENT.STATUS%type := 3;     

    -- Сообщения ошибок --   
    c_error_msg_empty_id       constant varchar2(250 char) := 'ID Поля не может быть пустым!';
    c_error_msg_empty_val      constant varchar2(250 char) := 'Значение в поле не может быть пустым!';
    c_error_msg_empty_coll     constant varchar2(250 char) := 'Коллекция не содержит данных!';
    c_error_msg_empty_reason   constant varchar2(250 char) := 'Причина не может быть пустой!';
    c_error_msg_empty_obj_id   constant varchar2(250 char) := 'ID объекта не может быть пустым!';

    -- Коды ошибкок --
    c_error_code_empty_par constant number(10) := -20002;    
    
    -- Объекты исключений --
    exp_empty_par exception;
    pragma exception_init(exp_empty_par, c_error_code_empty_par);

    -- Создание платежа --
    function f_create_payment(p_pay_cr_sum     PAYMENT.SUMMA%type,
                              p_pay_cr_date    PAYMENT.CREATE_DTIME%type,
                              p_pay_cr_cur_id  PAYMENT.CURRENCY_ID%type,
                              p_pay_cr_from_id PAYMENT.FROM_CLIENT_ID%type, 
                              p_pay_cr_to_id   PAYMENT.TO_CLIENT_ID%type,
                              p_pay_ct_data    t_payment_detail_array) 
    return payment_detail.PAYMENT_ID%type;

    -- Сброс платежа -- 
    procedure pr_fail_payment(p_payment_id    PAYMENT.PAYMENT_ID%type,
                              p_reset_reason  PAYMENT.STATUS_CHANGE_REASON%type); 

    -- Отмена платежа --
    procedure pr_cancel_payment(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                p_cancel_reason  PAYMENT.STATUS_CHANGE_REASON%type); 


    -- Завершение платежа --
    procedure pr_successful_finish_payment(p_payment_id PAYMENT.PAYMENT_ID%type);
    

end payment_api_pack;
/