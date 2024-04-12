begin
       RES:= UTL_HTTP.GET_RESPONSE(REQ);
       v_Status_Code := RES.Status_Code;
     exception
       when others then
          o_Ora_Msg := sqlerrm
  
           if RES.Reason_Phrase is not null then
             o_Ora_Msg := o_Ora_Msg || ',  http read error Reason_Phrase: ' || RES.Reason_Phrase;
           end if;
    
           if RES.Private_Hndl is not null then
             o_Ora_Msg := o_Ora_Msg || ',  Private_Hndl: ' || RES.Private_Hndl;
           end if;
    
           if Utl_Http.Get_Detailed_Sqlerrm is not null then
             o_Ora_Msg := o_Ora_Msg || ',  Get_Detailed_Sqlerrm: ' || Utl_Http.Get_Detailed_Sqlerrm;
           end if;
    
           if Utl_Http.Get_Detailed_Sqlcode is not null then
             o_Ora_Msg := o_Ora_Msg || ', Get_Detailed_Sqlcode: ' || Utl_Http.Get_Detailed_Sqlcode;
           end if;
    
           begin
             v_Status_Code := RES.Status_Code;
           exception
             when others then
               v_Status_Code := -1;
           end;
  
           if v_Status_Code is null then
             v_Status_Code := -5;
           end if;
 end;