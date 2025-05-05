declare 

 type t_info_client is record (
   id       PLS_INTEGER,
   status   INTEGER(1) NOT NULL := 1,
   blocked  INTEGER(1) := 0  
 ); 
   
 v_info_client       t_info_client;
 v_info_client_blck  t_info_client;
 
 v_pay_detail_info payment_detail_field%rowtype;

begin
  
 SELECT pdf.* 
 INTO v_pay_detail_info
 FROM payment_detail_field pdf 
 WHERE FIELD_ID = 1;
 
  dbms_output.put_line('Наименование: ' || v_pay_detail_info.NAME || '. Описание: '|| v_pay_detail_info.DESCRIPTION);  

 -- Выведем все записи --
  for i in (SELECT * FROM payment_detail_field) loop
    v_pay_detail_info := i;
    dbms_output.put_line('Наименование: ' || TO_CHAR(i.NAME) || '. Описание: '|| TO_CHAR(i.DESCRIPTION) );  
  end loop;
  
  
 v_info_client.id := 99999999;  
 v_info_client_blck.id := 0;
 
 dbms_output.put_line('ID: '|| v_info_client.id);
 dbms_output.put_line('Blocked ID: '|| v_info_client_blck.id);
 
 v_info_client := null;
   
 if v_info_client.id is null and v_info_client.status is null and v_info_client.blocked is null then 
     dbms_output.put_line('It’s null');
 else 
    dbms_output.put_line('It’s not null');
 end if; 
                  
end;
/
