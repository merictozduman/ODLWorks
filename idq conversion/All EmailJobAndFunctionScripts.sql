
-----------------------------------------------JOB STEPS PROCEDURES---------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_EMAIL_PRE_PROCESS(
vEmail IN Varchar2,
in_email OUT varchar2
) AS
BEGIN
    --2-std turkish_char
    IF vEmail IS NULL THEN 
    in_email := NULL;--'NULL ERROR';
    END IF;
    
     IF vEmail IS NOT NULL THEN 
      in_email:=REPLACE_STRING_BY_TBL('MAIL','STEP1',FNC_TRIM(vEmail));
     END IF;
    
  --  dbms_output.put_line('vEmail: '||vEmail||'in_email: '||in_email);
END ;

------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_EMAIL_DECOMPOSITION (
in_email IN varchar2,
var_email_lower OUT varchar2,
var_domain_lower OUT varchar2,
var_email_reverse OUT varchar2,
exp_undefined_character OUT varchar2,
exp_undefined_character_length OUT NUMBER,
exp_email_subdomain OUT VARCHAR2,
exp_email_user_name OUT VARCHAR2,
exp_email_user_name_length out NUMBER,
std_email_without_symbol OUT VARCHAR2,
exp_email_without_symbol_length OUT NUMBER,
exp_email_character_first_order OUT NUMBER
)
AS 
var_email_character_first_order NUMBER(5);
BEGIN 
	  var_email_lower := LOWER(in_email);

	 IF fnc_get_domain(in_email) IS NULL THEN 
		var_domain_lower:=NULL ;
	 else
		var_domain_lower:=LOWER(fnc_get_domain(in_email));
	 END if;
	
     var_email_reverse := FNC_REVERSE(LOWER(in_email));	
   
     exp_undefined_character :=FNC_ADVANCED_REPLACE(var_email_lower)||FNC_ADVANCED_REPLACE(var_domain_lower);
	 exp_undefined_character_length := LENGTH(exp_undefined_character);
   
	 exp_email_subdomain :=FNC_GET_SUBDOMAIN(var_email_lower); 
	
	 exp_email_user_name :=SUBSTR(var_email_lower , 1 , INSTR(var_email_lower,'@',1,1)-1);
	 exp_email_user_name_length  := LENGTH(exp_email_user_name);
	
	 std_email_without_symbol:=REPLACE(REPLACE(REPLACE(REPLACE(var_email_lower,'@',''),'-',''),'.',''),'_','');
     exp_email_without_symbol_length :=length(std_email_without_symbol);
	 
	 exp_email_character_first_order:= INSTR(var_email_lower ,'@')   ;
   
	
END;


------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure PRC_EMAIL_VALIDATION
   ( 
   exp_email_subdomain IN varchar2,
   exp_email_user_name IN varchar2,
    Tkn_subdomain_pattern OUT varchar2, 
    TokenizedData2 OUT varchar2,
    Tkn_username_noise OUT varchar2,
	tokenizedData5 OUT varchar2
     )
IS

StrStgDomain varchar2(300);
StrStgNoise varchar2(300);

BEGIN

	IF FNC_SEARCH_IN_TABLE('REF_EMAIL_DOMAIN','EMAIL_DOMAIN',exp_email_subdomain)=1 THEN
  		Tkn_subdomain_pattern:='valid';
  	ELSE    
        TokenizedData2:='invalid';
        Tkn_subdomain_pattern:='invalid';
	END IF;      
	
	IF FNC_SEARCH_IN_TABLE('ref_email_noise','email_noise',exp_email_user_name)=1 THEN
	  		Tkn_username_noise:='valid';
	ELSE    
	        tokenizedData5:='invalid';
	        Tkn_username_noise:='invalid';
	END IF;      
	
END;

------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_EMAIL_CHECK_QUALITY(
    in_email IN VARCHAR2,
    exp_undefined_character_length IN NUMBER,
    exp_email_without_symbol_length IN NUMBER,
    exp_email_user_name_length IN number,
    exp_email_character_first_order IN NUMBER,
    tkn_username_noise IN VARCHAR2,
    tkn_subdomain_pattern IN VARCHAR2,
    dec_email_quality_detail_code OUT VARCHAR2,
    dec_cl_email OUT VARCHAR2
) AS
BEGIN

/*	
    -- Email verisi boş olmamalıdır
    IF in_email IS NULL OR LENGTH(in_email) = 0 THEN
        dec_email_quality_detail_code := '-' || 'genbos00';
    END IF;
*/
    -- "@, -, _, ." işaretleri ve harf rakam karakterleri dışındaki diğer karakterler olmamalıdır
    IF nvl(exp_undefined_character_length,0) > 0 THEN
        dec_email_quality_detail_code := dec_email_quality_detail_code || '-' || 'emlgec01';
    END IF;

    -- "@, -, _, ." işaretlerinin çıkartılmasından sonra, uzunluğu 5 karaktere eşit ve az olmamalıdır
    IF nvl(exp_email_without_symbol_length,0) <= 5 THEN
        dec_email_quality_detail_code := dec_email_quality_detail_code || '-' || 'emlgec02';
    END IF;

    -- Email verisi içinde kullanıcı adı uzunluğu 2 karaktere az olmamalıdır
    IF exp_email_user_name_length < 2 AND exp_email_character_first_order > 0 THEN
        dec_email_quality_detail_code := dec_email_quality_detail_code|| '-' || 'emlgec05';
    END IF;

    -- Email kullanıcı adı bilgisi sadece referans kütüphanesinde belirtilen kelimelerden oluşmamalıdır
    IF tkn_username_noise = 'valid' THEN
        dec_email_quality_detail_code := NVL(dec_email_quality_detail_code, '') || '-' || 'emlgec06';
    END IF;

    -- E-Mail verisi içinde ‘@’ karakteri bulunmalıdır
    IF exp_email_character_first_order = 0 THEN
        dec_email_quality_detail_code := dec_email_quality_detail_code || '-' || 'emlgec07';
    END IF;

    -- E-Mail alt domain uzantısı bilgisi (com, com.tr v.b.) geçerli kayıt referans kütüphanesinde yer almalıdır
    IF tkn_subdomain_pattern <> 'valid' THEN
        dec_email_quality_detail_code := dec_email_quality_detail_code|| '-' || 'emlprb09';
    END IF;

    -- Sonuç
    IF dec_email_quality_detail_code IS null THEN
        dec_email_quality_detail_code := 'genkal00';
        dec_cl_email := in_email;
    ELSE
        dec_email_quality_detail_code := SUBSTR(dec_email_quality_detail_code, 2, LENGTH(dec_email_quality_detail_code) - 1);
        dec_cl_email := '';
    END IF;
   
END ;

--------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL_MAIN_PROCEDURE (
    vEmail IN VARCHAR2,
    result_email_quality_detail_code OUT VARCHAR2,
    result_cl_email OUT VARCHAR2
)
AS
    in_email VARCHAR2(400);
    var_email_lower VARCHAR2(400);
    var_domain_lower VARCHAR2(400);
    var_email_reverse VARCHAR2(400);
    exp_undefined_character VARCHAR2(400);
    exp_undefined_character_length NUMBER;
    exp_email_subdomain VARCHAR2(400);
    exp_email_user_name VARCHAR2(400);
    exp_email_user_name_length NUMBER;
    std_email_without_symbol VARCHAR2(400);
    exp_email_without_symbol_length NUMBER;
    exp_email_character_first_order NUMBER;
    Tkn_subdomain_pattern VARCHAR2(50);
    TokenizedData2 VARCHAR2(50);
    Tkn_username_noise VARCHAR2(50);
    tokenizedData5 VARCHAR2(50);
    dec_email_quality_detail_code VARCHAR2(100);
    dec_cl_email VARCHAR2(400);
BEGIN
	
    IF vEmail IS NULL OR FNC_TRIM(vEmail) IS NULL THEN
          result_email_quality_detail_code := 'genbos00';
          result_cl_email := '';
/*         
          dbms_output.put_line('mail is null check-Out dec_email_quality_detail_code = ' || dec_email_quality_detail_code );
          dbms_output.put_line('mail is null check-Out dec_cl_email = ' || dec_cl_email );
 */    
    END IF;	

    IF vEmail IS NOT NULL AND FNC_TRIM(vEmail) IS NOT NULL THEN
			IF FNC_SEARCH_IN_TABLE('MDM_CRM_EMAIL_STACK','emailaddress',vEmail)=0 THEN 
    
						    -- Call PRC_EMAIL_PRE_PROCESS
						    PRC_EMAIL_PRE_PROCESS(vEmail, in_email);
						/*
						    dbms_output.put_line('PRC_EMAIL_PRE_PROCESS-vEmail = ' || vEmail ); 
						    dbms_output.put_line('PRC_EMAIL_PRE_PROCES-in_email = ' || in_email ); 
						 */
						
						    -- Call PRC_EMAIL_DECOMPOSITION
						    PRC_EMAIL_DECOMPOSITION(
						        in_email,
						        var_email_lower,
						        var_domain_lower,
						        var_email_reverse,
						        exp_undefined_character,
						        exp_undefined_character_length,
						        exp_email_subdomain,
						        exp_email_user_name,
						        exp_email_user_name_length,
						        std_email_without_symbol,
						        exp_email_without_symbol_length,
						        exp_email_character_first_order
						    );
						
						  /*
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- in_email= ' || in_email ); 
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- var_email_lower= ' || var_email_lower );
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- var_domain_lower= ' ||  var_domain_lower);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- var_email_reverse= ' ||  var_email_reverse);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_undefined_character= ' ||  exp_undefined_character);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_undefined_character_length= ' ||  exp_undefined_character_length);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_email_subdomain= ' ||  exp_email_subdomain);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_email_user_name= ' ||  exp_email_user_name);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_email_user_name_length= ' ||  exp_email_user_name_length);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- std_email_without_symbol= ' ||  std_email_without_symbol);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_email_without_symbol_length= ' ||  exp_email_without_symbol_length);
						    dbms_output.put_line('PRC_EMAIL_DECOMPOSITION- exp_email_character_first_order= ' ||  exp_email_character_first_order);
						*/
						   
						    -- Call PRC_EMAIL_VALIDATION
						    PRC_EMAIL_VALIDATION(
						        exp_email_subdomain,
						        exp_email_user_name,
						        Tkn_subdomain_pattern,
						        TokenizedData2,
						        Tkn_username_noise,
						        tokenizedData5
						    );
						/*   
						
							dbms_output.put_line('PRC_EMAIL_VALIDATION- exp_email_subdomain = '   || exp_email_subdomain ); 
							dbms_output.put_line('PRC_EMAIL_VALIDATION- exp_email_user_name = '   || exp_email_user_name ); 
							dbms_output.put_line('PRC_EMAIL_VALIDATION- Tkn_subdomain_pattern = ' || Tkn_subdomain_pattern ); 
							dbms_output.put_line('PRC_EMAIL_VALIDATION- TokenizedData2 = '        || TokenizedData2 ); 
							dbms_output.put_line('PRC_EMAIL_VALIDATION- Tkn_username_noise = '    || Tkn_username_noise ); 
							dbms_output.put_line('PRC_EMAIL_VALIDATION- tokenizedData5 = '        || tokenizedData5 ); 
						*/
						   
						    -- Call PRC_EMAIL_CHECK_QUALITY
						    PRC_EMAIL_CHECK_QUALITY(
						        var_email_lower,
						        exp_undefined_character_length,
						        exp_email_without_symbol_length,
						        exp_email_user_name_length,
						        exp_email_character_first_order,
						        Tkn_username_noise,
						        Tkn_subdomain_pattern,
						        dec_email_quality_detail_code,
						        dec_cl_email
						    );
						 
						 /* 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- var_email_lower = '                  || var_email_lower ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- exp_undefined_character_length = '   || exp_undefined_character_length ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- exp_email_without_symbol_length = '  || exp_email_without_symbol_length ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- exp_email_user_name_length = '       || exp_email_user_name_length ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- exp_email_character_first_order = '  || exp_email_character_first_order ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- Tkn_username_noise = '               || Tkn_username_noise ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- Tkn_subdomain_pattern = '            || Tkn_subdomain_pattern ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- dec_email_quality_detail_code = '    || dec_email_quality_detail_code ); 
							dbms_output.put_line('PRC_EMAIL_CHECK_QUALITY- dec_cl_email = '                     || dec_cl_email ); 
						*/
						    -- Set output parameters
						    result_email_quality_detail_code := dec_email_quality_detail_code;
						    result_cl_email := dec_cl_email;
					INSERT INTO MDM_CRM_EMAIL_STACK VALUES (vEmail,result_cl_email,result_email_quality_detail_code );COMMIT;
				    --dbms_output.put_line('MDM_CRM_EMAIL_STACK insert gerçekleşti');	   
			 
		      ELSE 		    
				    SELECT email_processed INTO result_cl_email FROM MDM_CRM_EMAIL_STACK WHERE emailaddress=vEmail;
				    SELECT email_quality_code INTO result_email_quality_detail_code FROM MDM_CRM_EMAIL_STACK WHERE emailaddress=vEmail;
				    --dbms_output.put_line('MDM_CRM_EMAIL_STACK okuma gerçekleşti');	  
			  END IF;			   						   
   	END IF;

END;
-----------------------------------------------JOB STEPS PROCEDURES ENDS---------------------------------------------------------

---------------------------For Test----------------------

DECLARE 
dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
BEGIN
	PRC_EMAIL_MAIN_PROCEDURE('merıcTOZDUMAN@HOTMAIL.COM',dec_email_quality_detail_code,dec_cl_email);
    dbms_output.put_line('dec_email_quality_detail_code= '||dec_email_quality_detail_code);
    dbms_output.put_line('dec_cl_email= '||dec_cl_email);
END;

----------------------------------------------------------

TRUNCATE TABLE QLICK.MDM_CRM_EMAIL_STACK

SELECT * FROM QLICK.MDM_CRM_EMAIL_STACK


DECLARE
    v_chunk_size CONSTANT NUMBER := 10000;
    v_phone_number VARCHAR2(50);
    v_counter NUMBER := 0;
    v_cnt_total NUMBER; 

BEGIN
  sELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.mt_test_sil2 ;
    FOR rec IN (SELECT EMAILADDRESS  FROM COMPOSECRML1.mt_test_sil2 ) LOOP
        v_counter := v_counter + 1;

        DECLARE
    dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
        BEGIN
     if rec.EMAILADDRESS is not null or rec.EMAILADDRESS!='' THEN
      PRC_EMAIL_MAIN_PROCEDURE(rec.EMAILADDRESS,dec_email_quality_detail_code,dec_cl_email);
         end if; 
   END;

        -- Check if the chunk size is reached or it's the last iteration
        IF MOD(v_counter, v_chunk_size) = 0 OR v_counter = v_cnt_total THEN
            COMMIT;
           -- dbms_output.put_line('v_counter: '||v_counter);
        END IF;
    END LOOP;
END;