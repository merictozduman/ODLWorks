CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL2_PRE_PROCESS AS
vEmail Varchar2(300);
in_email varchar2(300);
BEGIN
    
	SELECT PARAMETER_VALUE INTO vEmail 
	FROM DQ_SP_RUN_ORDER 
	WHERE RUN_ORDER =1 AND PARAMETER_NAME ='vEmail' AND SUBJECT_NAME ='MAIL';

    
    in_email:=lower(REPLACE_STRING_BY_TBL('MAIL','STEP1',FNC_TRIM(vEmail)));
    PRC_DQ_SP_RUN_UPD('MAIL',1,'in_email',in_email) ;
    PRC_DQ_SP_RUN_UPD('MAIL',2,'in_email',in_email) ;
    PRC_DQ_SP_RUN_UPD('MAIL',4,'in_email',in_email) ;
   
    dbms_output.put_line('vEmail: '||vEmail||'in_email: '||in_email);
     
    COMMIT;
END ;
----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL2_DECOMPOSITION as
in_email varchar2(300);
var_email_lower varchar2(300);
var_domain_lower varchar2(300);
var_email_reverse varchar2(300);
exp_undefined_character varchar2(300);
exp_undefined_character_length NUMBER;
exp_email_subdomain VARCHAR2(300);
exp_email_user_name VARCHAR2(300);
exp_email_user_name_length NUMBER;
std_email_without_symbol VARCHAR2(300);
exp_email_without_symbol_length NUMBER;
exp_email_character_first_order NUMBER;
--var_email_character_first_order NUMBER;
BEGIN 
	 
	 SELECT PARAMETER_VALUE INTO in_email  
     FROM DQ_SP_RUN_ORDER 
	 WHERE RUN_ORDER =2 AND PARAMETER_NAME ='in_email' AND SUBJECT_NAME ='MAIL';
	
	
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
	

		PRC_DQ_SP_RUN_UPD('MAIL',2,'var_email_lower',var_email_lower) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'var_domain_lower',var_domain_lower) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'var_email_reverse',var_email_reverse) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_undefined_character',exp_undefined_character) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_undefined_character_length',exp_undefined_character_length) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_email_subdomain',exp_email_subdomain) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_email_user_name',exp_email_user_name) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_email_user_name_length',exp_email_user_name_length) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'std_email_without_symbol',std_email_without_symbol) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_email_without_symbol_length',exp_email_without_symbol_length) ;
		PRC_DQ_SP_RUN_UPD('MAIL',2,'exp_email_character_first_order',exp_email_character_first_order);
		
		PRC_DQ_SP_RUN_UPD('MAIL',3,'exp_email_subdomain',exp_email_subdomain) ;
		PRC_DQ_SP_RUN_UPD('MAIL',3,'exp_email_user_name',exp_email_user_name) ;
	
	    PRC_DQ_SP_RUN_UPD('MAIL',4,'exp_undefined_character_length',exp_undefined_character_length);
	    PRC_DQ_SP_RUN_UPD('MAIL',4,'exp_email_without_symbol_length',exp_email_without_symbol_length);
	   	PRC_DQ_SP_RUN_UPD('MAIL',4,'exp_email_user_name_length',exp_email_user_name_length);
	    PRC_DQ_SP_RUN_UPD('MAIL',4,'exp_email_character_first_order',exp_email_character_first_order);

	   
END;

----------------------------------------------------------------------------------

CREATE OR REPLACE procedure QLICK.PRC_EMAIL2_VALIDATION
   AS
   exp_email_subdomain varchar2(300);
   exp_email_user_name varchar2(300);
   Tkn_subdomain_pattern varchar2(300); 
   TokenizedData2 varchar2(300);
   Tkn_username_noise varchar2(300);
   tokenizedData5 varchar2(300);
     
BEGIN

     SELECT PARAMETER_VALUE INTO exp_email_subdomain 
     FROM DQ_SP_RUN_ORDER 
	 WHERE RUN_ORDER =3 AND PARAMETER_NAME ='exp_email_subdomain' AND SUBJECT_NAME ='MAIL';

	 SELECT PARAMETER_VALUE INTO exp_email_user_name 
     FROM DQ_SP_RUN_ORDER 
	 WHERE RUN_ORDER =3 AND PARAMETER_NAME ='exp_email_user_name' AND SUBJECT_NAME ='MAIL';

	
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

	PRC_DQ_SP_RUN_UPD('MAIL',3,'Tkn_subdomain_pattern',Tkn_subdomain_pattern) ;
	PRC_DQ_SP_RUN_UPD('MAIL',3,'TokenizedData2',TokenizedData2) ;
	PRC_DQ_SP_RUN_UPD('MAIL',3,'Tkn_username_noise',Tkn_username_noise) ;
	PRC_DQ_SP_RUN_UPD('MAIL',3,'tokenizedData5',tokenizedData5) ;

	PRC_DQ_SP_RUN_UPD('MAIL',4,'tkn_subdomain_pattern',Tkn_subdomain_pattern) ;
	PRC_DQ_SP_RUN_UPD('MAIL',4,'tkn_username_noise',Tkn_username_noise) ;

END;

----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL_CHECK_QUALITY(
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

----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL2_MAIN (
    vEmail IN VARCHAR2,
    dec_email_quality_detail_code OUT VARCHAR2,
    dec_cl_email OUT VARCHAR2
) AS
v_sql varchar2(4000);
BEGIN
	
UPDATE DQ_SP_RUN_ORDER SET PARAMETER_VALUE=NULL WHERE SUBJECT_NAME ='MAIL';COMMIT;
PRC_DQ_SP_RUN_UPD('MAIL',1,'vEmail',vEmail) ; 
	
    IF vEmail IS NULL OR FNC_TRIM(vEmail) IS NULL THEN
   
          dec_email_quality_detail_code := 'genbos00';
          dec_cl_email := '';
          dbms_output.put_line('mail is null check-Out dec_email_quality_detail_code = ' || dec_email_quality_detail_code );
          dbms_output.put_line('mail is null check-Out dec_cl_email = ' || dec_cl_email );    
         
    END IF;
   
    IF vEmail IS NOT NULL AND FNC_TRIM(vEmail) IS NOT NULL THEN
		    
		    FOR sp_row IN (SELECT DISTINCT SP_NAME,RUN_ORDER  FROM DQ_SP_RUN_ORDER WHERE SUBJECT_NAME ='MAIL' ORDER BY RUN_ORDER) LOOP
		        v_sql := 'BEGIN ' || sp_row.SP_NAME || '; END;';
		        EXECUTE IMMEDIATE v_sql;
		    END LOOP;
		  
		        SELECT PARAMETER_VALUE INTO dec_email_quality_detail_code 
		        FROM DQ_SP_RUN_ORDER
		        WHERE RUN_ORDER = 4 AND PARAMETER_NAME = 'dec_email_quality_detail_code' AND SUBJECT_NAME ='MAIL';
		
		        SELECT PARAMETER_VALUE INTO dec_cl_email
		        FROM DQ_SP_RUN_ORDER
		        WHERE RUN_ORDER =4 AND PARAMETER_NAME = 'dec_cl_email' AND SUBJECT_NAME ='MAIL';

     END IF;
   
COMMIT;
END ;

--------------------------------TEST SCRIPT--------------------------------------------------

--Diger adımlar için, dq_sp_run_order tablosuna parametereler girilip, sp'ler parametresiz olarak çağırılabilir. 
--Çağırılan adımlar sonuçları yine aynı tabloya yazacaktır.

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

