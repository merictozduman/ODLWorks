declare

  v_content varchar2(32000);
  v_isSuccess varchar2(4000);

v_customerAddress_template varchar2(32000) :='{
  "AccountCode": "${AccountCode}",
  "ContactCode": "${ContactCode}",
  "Address": "${Address}",
  "AddressTypeCode": "${AddressTypeCode}",
  "StateCode": ${StateCode},
  "CityCode": "${CityCode}",
  "CountyCode": "${CountyCode}",
  "District": "${District}",
  "IsCommunication": "${IsCommunication}",
  "ModifiedOn": "${ModifiedOn}",
  "NationalityCode": "${NationalityCode}",
  "OwnerShipSet": "${OwnerShipSet}",
  "PostalCode": "${PostalCode}",
  "RecordNumber": "${RecordNumber}",
  "ResidenceData": "${ResidenceData}"
}';

  
  function createOrUpdateCustomerAddress(p_APIContent varchar2) return varchar2
  is
    v_req utl_http.req;
    v_res utl_http.resp;
    v_url varchar2(4000) := 'http://apicrmtest.fw.eurekosigorta.com.tr:8080/api/CustomerAddress/CreateCustomerAddress';
    v_buffer varchar2(32767);
    v_data varchar2(32767);
    v_json_data varchar2(32767);
  begin
    v_req  :=UTL_HTTP.begin_request(v_url, 'POST');

      utl_http.set_header(v_req, 'Content-Type', 'application/json; charset=utf-8');
      utl_http.set_header(v_req, 'Content-Length', lengthb(convert(p_APIContent, 'AL32UTF8')));
      utl_http.set_header(v_req, 'Accept', 'application/json');
      utl_http.set_header(v_req, 'api_key', '16583799-7fa0-41f5-a2b4-63ae2600b70e'); -- yeni APIde api key degisirse burayi degistirmek gerekecektir
      
      
      
      utl_http.write_text(v_req, convert(p_APIContent, 'AL32UTF8'));
    
      v_res := utl_http.get_response(v_req);
      -- process the response from the HTTP call
      begin
        loop
          utl_http.read_text(v_res, v_buffer,32767);

          v_json_data := v_json_data || v_buffer;
        end loop;
        utl_http.end_response(v_res);
      exception
        when utl_http.end_of_body
        then
          utl_http.end_response(v_res);
      end;


      v_data := substr(v_json_data, 1, 4000);
      return v_data;
      
      
  end;
  
  function formatdate(p_date date) return varchar2
  is
  begin
    return to_char(coalesce(p_date,sysdate), 'YYYY-MM-DD')||'T'||to_char(coalesce(p_date,sysdate), 'HH24:MI:SS')||'.765Z';
  end;
  
  function formatdecimal(p_decimal number) return varchar2
  is
  begin
    return case when p_decimal is null or p_decimal = 0 then '0.00' else to_char(round(p_decimal,2), 'FM99999999.90', 'NLS_NUMERIC_CHARACTERS='',.''') end;
  end;
BEGIN
  

 for rec_customeraddress in (select p.ACCOUNTCODE,
                             		p.CONTACTCODE,
                             		p.ADDRESS,
                             		p.ADDRESSTYPECODE,
                             		p.STATECODE,
                             		p.CITYCODE,
                             		p.COUNTYCODE,
                             		p.DISTRICT,
                             		p.ISCOMMUNICATION,
                             		p.MODIFIEDON,
                             		p.NATIONALITYCODE,
                             		p.OWNERSHIPSET,
                             		p.POSTALCODE,
                             		p.RECORDNUMBER,
                             		p.RESIDENCEDATE
                          from DWH_Layer2.TDWH_CORE_CUSTOMERADDRESSINFORMATION_HUB p
                           --where p.runno_update = (select max(runno) from dwh_layer2.tpil_runs where PI_VERSION like '%ETL Set: 43%')
                             where p.runno_update = 2235
                           --  and rownum = 1
                            ) loop

    
    v_content := v_customerAddress_template;
    
    
    v_content := replace(v_content, '${AccountCode}', rec_customeraddress.ACCOUNTCODE);
    v_content := replace(v_content, '${ContactCode}', rec_customeraddress.CONTACTCODE);
    v_content := replace(v_content, '${Address}', rec_customeraddress.ADDRESS);
    v_content := replace(v_content, '${AddressTypeCode}', rec_customeraddress.ADDRESSTYPECODE);
    v_content := replace(v_content, '${StateCode}', rec_customeraddress.STATECODE);
    v_content := replace(v_content, '${CityCode}', rec_customeraddress.CITYCODE);
    v_content := replace(v_content, '${CountyCode}', rec_customeraddress.COUNTYCODE);
    v_content := replace(v_content, '${District}', rec_customeraddress.DISTRICT);
    v_content := replace(v_content, '${IsCommunication}', rec_customeraddress.ISCOMMUNICATION);
    v_content := replace(v_content, '${ModifiedOn}', formatdate(rec_customeraddress.MODIFIEDON));
    v_content := replace(v_content, '${NationalityCode}', rec_customeraddress.NATIONALITYCODE);
    v_content := replace(v_content, '${OwnerShipSet}', rec_customeraddress.OWNERSHIPSET);
    v_content := replace(v_content, '${PostalCode}', rec_customeraddress.POSTALCODE);
    v_content := replace(v_content, '${RecordNumber}', rec_customeraddress.RECORDNUMBER);
    v_content := replace(v_content, '${ResidenceData}', formatdate(rec_customeraddress.RESIDENCEDATE));
    

    v_isSuccess := createOrUpdateCustomerAddress(v_content);
    
    /* Log atilmak istenirse acilabilir
    insert into dwh_layer2.dwh_service_log(log_txt, log_dt)
    values(substr('ACCOUNTCODE:'||rec_customeraddress.ACCOUNTCODE || '-RECORDNUMBER:' || rec_customeraddress.RECORDNUMBER ||v_isSuccess,1,3990), sysdate);
    commit;
    */
    
    
 end loop;


end;
