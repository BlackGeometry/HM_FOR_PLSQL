create or replace package payment_api_pack is
/*
Автор: Kovalenko K.E.
Описание скрипта: API для сущностей “Платеж”
*/

    -- Создание платежа --
    function f_create_payment(p_pay_cr_sum       PAYMENT.SUMMA%type,
                              p_pay_cr_date      PAYMENT.CREATE_DTIME%type,
                              p_pay_cr_cur_id    PAYMENT.CURRENCY_ID%type,
                              p_pay_cr_from_id   PAYMENT.FROM_CLIENT_ID%type,
                              p_pay_cr_to_id     PAYMENT.TO_CLIENT_ID%type,
                              p_pay_ct_data_arr  t_payment_detail_array)
    return payment_detail.PAYMENT_ID%type;

    -- Сброс платежа --
    procedure pr_fail_payment(p_payment_id    PAYMENT.PAYMENT_ID%type,
                              p_reset_reason  PAYMENT.STATUS_CHANGE_REASON%type);

    -- Отмена платежа --
    procedure pr_cancel_payment(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                p_cancel_reason  PAYMENT.STATUS_CHANGE_REASON%type);


    -- Завершение платежа --
    procedure pr_successful_finish_payment(p_payment_id PAYMENT.PAYMENT_ID%type);

    -- Проверка DML через API --
    procedure pr_dml_api_check;

    -- Проверка DML не через API --
    procedure pr_without_api_dml_check;
    
    -- Блокировка по платежу -- 
    procedure try_lock_payment(p_payment_id PAYMENT.PAYMENT_ID%type);
     
end payment_api_pack;
/