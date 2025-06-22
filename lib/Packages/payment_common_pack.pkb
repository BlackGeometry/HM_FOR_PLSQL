create or replace package body payment_common_pack is

  -- Признак текущего статуса DML в обход API --
  g_enable_manual_changes boolean := false;
    
  -- Процедура вклюения DML в обход API --
  procedure pr_without_api_dml_enable as
    begin 
      g_enable_manual_changes := true;
    end pr_without_api_dml_enable;
      
  -- Процедура отключения DML в обход API -- 
  procedure pr_without_api_dml_disable as
    begin 
      g_enable_manual_changes := false;
    end pr_without_api_dml_disable;
    
  function f_dml_api_check return boolean as
    begin 
      g_enable_manual_changes := false;
    end f_dml_api_check;   
  
  
end payment_common_pack;
/
