

declare 
    var1 varchar2(300);

BEGIN
	
    QLICK.PKG_EMAIL_PROCESS.PRC_EMAIL_STEP2(null, var1);
    dbms_output.put_line('var1 = ' || var1);
   
    IF var1 IS NULL THEN 
     dbms_output.put_line('null deger'); 
    END IF;
   
end;


declare 
    var_email_lower varchar2(300);
    var_domain_lower varchar2(300);
    var_email_reverse varchar2(300);
BEGIN
	
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP3_1('MERICTOZDUMAN@HOTMAIL.COM', var_email_lower ,var_domain_lower,var_email_reverse);
    dbms_output.put_line('var1 = ' || var_email_lower);
    dbms_output.put_line('var2 = ' || var_domain_lower);
    dbms_output.put_line('var3 = ' || var_email_reverse);
end;


declare 
    exp_undefined_character varchar2(300);
    exp_email_subdomain varchar2(300);
    exp_email_lower varchar2(300);
    exp_email_user_name varchar2(300);
BEGIN
	
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP3_2('merictozduman@hotmail.com','hotmail','moc.liamtoh@namudzotcirem', exp_undefined_character ,exp_email_subdomain, exp_email_lower,exp_email_user_name);
    dbms_output.put_line('var1 = ' || exp_undefined_character);
    dbms_output.put_line('var2 = ' || exp_email_subdomain);
    dbms_output.put_line('var3 = ' || exp_email_lower);
    dbms_output.put_line('var4 = ' || exp_email_user_name);
end;

	declare 
    Tkn_subdomain_pattern varchar2(300);
    TokenizedData2  varchar2(300);
    Tkn_username_noise varchar2(300);
    tokenizedData5 varchar2(300);
    std_email_without_symbol varchar2(300);
BEGIN
	
      PKG_EMAIL_PROCESS.PRC_EMAIL_STEP4('hotmail','merictozduman','merictozduman@hotmail.com', 
     Tkn_subdomain_pattern ,
     TokenizedData2 , 
     Tkn_username_noise ,
     tokenizedData5 ,
     std_email_without_symbol
     );
    dbms_output.put_line('var1 = ' || Tkn_subdomain_pattern); 
    dbms_output.put_line('var2 = ' || TokenizedData2 );
    dbms_output.put_line('var3 = ' || Tkn_username_noise);
    dbms_output.put_line('var4 = ' || tokenizedData5);
    dbms_output.put_line('var5 = ' || std_email_without_symbol);
    
end;

CREATE TABLE qlick.ref_email_domain (email_domain varchar2(300))
CREATE TABLE qlick.ref_email_noise(email_noise varchar2(300))
INSERT INTO qlick.ref_email_domain values('hotmail')
INSERT INTO qlick.ref_email_noise values('merictozduman1')

declare 
    var1 number;

BEGIN
	
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP5_1('merictozduman@hotmail.com', var1);
    dbms_output.put_line('var1 = ' || var1);
 
end;


declare 

		exp_undefined_character_length  number(10);
		exp_email_without_symbol_length number(10);
		exp_email_user_name number;
		exp_email_character_first_order number(10);
	
BEGIN
	
    QLICK.PRC_EMAIL_STEP5_2(
							null,
							'merictozdumanhotmailcom',
							'merictozduman@hotmail.com	', 
							14,
							exp_undefined_character_length,
							exp_email_without_symbol_length,
							exp_email_user_name,
							exp_email_character_first_order 
							 );
    dbms_output.put_line('var1 = ' || exp_undefined_character_length); 
    dbms_output.put_line('var2 = ' || exp_email_without_symbol_length );
    dbms_output.put_line('var3 = ' || exp_email_user_name);
    dbms_output.put_line('var4 = ' || exp_email_character_first_order );
    
end;

DECLARE 
   in_email VARCHAR2(300);
    exp_undefined_character_length NUMBER(10);
    exp_email_without_symbol_length NUMBER(10);
    exp_email_user_name number(10);
    exp_email_character_first_order NUMBER(10);
    tkn_username_noise VARCHAR2(300);
    tkn_subdomain_pattern VARCHAR(300);
    dec_email_quality_detail_code VARCHAR2(300);
    dec_cl_email VARCHAR2(300);

BEGIN
	
	PKG_EMAIL_PROCESS.check_email_quality(
							    'merictozduman@hotmail.com' ,
						    null,
						    23 ,
						    13,
						    14 ,
						    'invalid',
						    'valid',
						    dec_email_quality_detail_code ,
						    dec_cl_email 
	);

    dbms_output.put_line('var1 = ' || dec_email_quality_detail_code ); 
    dbms_output.put_line('var2 = ' || dec_cl_email );


END;


DECLARE 
dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
BEGIN
	PKG_EMAIL_PROCESS.MAIN_EMAIL_PROCESS('m@hotmail.com',dec_email_quality_detail_code,dec_cl_email);
    dbms_output.put_line('dec_email_quality_detail_code= '||dec_email_quality_detail_code);
    dbms_output.put_line('dec_cl_email= '||dec_cl_email);
END;

SELECT CASE WHEN FNC_TRIM('	')  IS NULL THEN 'ASD' END AS XX FROM DUAL    
    
    
DECLARE
   
	    vEmail VARCHAR2(300);
	    dec_email_quality_detail_code VARCHAR2(300);
	    dec_cl_email VARCHAR2(300);

BEGIN
	
	PKG_EMAIL_PROCESS.MAIN_EMAIL_PROCESS('asd',dec_email_quality_detail_code,dec_cl_email);
    dbms_output.put_line('var1 = ' || dec_email_quality_detail_code); 
    dbms_output.put_line('var2 = ' || dec_cl_email );

END;

DECLARE
  vEmail VARCHAR2(100) := '8fGjEC1@qgg.ii' ;
  dec_email_quality_detail_code VARCHAR2(50);
  dec_cl_email VARCHAR2(50);
BEGIN
  QLICK.PRC_EMAIL2_MAIN(vEmail, dec_email_quality_detail_code, dec_cl_email);

  -- Display results
  DBMS_OUTPUT.PUT_LINE('Input Email: ' || vEmail);
  DBMS_OUTPUT.PUT_LINE('Output dec_email_quality_detail_code: ' || dec_email_quality_detail_code);
  DBMS_OUTPUT.PUT_LINE('Output dec_cl_email: ' || dec_cl_email);
END;

