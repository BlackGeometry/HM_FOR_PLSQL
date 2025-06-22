Create or replace package payment_detail_api_pack  is 
/*
Автор: Kovalenko K.E.
Описание скрипта: API для сущностей “Детали платежа” 
*/
   
    -- Данные платежа --
    procedure pr_insert_or_update_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                                 p_pay_data_arr   t_payment_detail_array);

    -- Детали платежа --
    procedure delete_payment_detail(p_payment_id     PAYMENT.PAYMENT_ID%type,
                                    p_pay_info_data  t_number_array);
                                    
    -- Проверка DML через API --
    procedure pr_dml_api_check;
                                    
end payment_detail_api_pack;
/