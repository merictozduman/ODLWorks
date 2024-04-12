---------------------------------------------------FUNCTIONS AND DEFINITION TABLES--------------------------------------

CREATE OR REPLACE FUNCTION QLICK.REPLACE_STRING_BY_TBL(
p_subject_name IN VARCHAR2,   
p_step_name   IN VARCHAR2,
p_input_string IN VARCHAR2
) RETURN VARCHAR2
AS
  v_search_string  VARCHAR2(1000);
  v_replace_string VARCHAR2(1000);
  v_stg_input_string VARCHAR2(1000);
BEGIN
  --  dbms_output.put_line('START-subject_name := '||p_subject_name);
  --  dbms_output.put_line('START-step_name := '||p_step_name);
  --  dbms_output.put_line('START-input_string := '||p_input_string );
	
  v_stg_input_string:=	p_input_string;
  -- Declare a cursor to select rows based on step_name
  FOR c IN (SELECT search_string, replace_string
            FROM replacement_table
            WHERE 1=1 
            AND step_name =p_step_name
            AND subject = p_subject_name
            ORDER BY run_order asc)
  LOOP
    -- Fetch values from the cursor
    v_search_string := c.search_string;
    v_replace_string := c.replace_string;

    -- Perform the replacement for each row
    v_stg_input_string := REPLACE(v_stg_input_string, v_search_string, v_replace_string);
    
--    dbms_output.put_line('v_search_string := '||v_search_string);
--    dbms_output.put_line('v_replace_string := '||v_replace_string);
--    dbms_output.put_line('v_stg_input_string := '||v_stg_input_string );
  END LOOP;
    
  -- Return the final result
  RETURN v_stg_input_string;
END REPLACE_STRING_BY_TBL;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_GET_DOMAIN(email_address Varchar2)
RETURN varchar2
IS 
        at_position NUMBER;
        dot_position NUMBER;
       domain_name varchar2(300);
        
BEGIN 

        at_position := INSTR(email_address, '@');
        
        -- Check if '@' symbol is found
        IF at_position > 0 THEN
		            -- Find the position of the first '.' after '@'
		            dot_position := INSTR(email_address, '.', at_position);
		            -- Check if '.' symbol is found		           
		            IF dot_position > 0 THEN
--		                subdomain_name := SUBSTR(email_address, at_position + 1, dot_position - at_position - 1);
		                domain_name := SUBSTR(email_address, at_position + 1, dot_position - at_position - 1);--SUBSTR(email_address, dot_position + 1);
		            ELSE
		                domain_name := SUBSTR(email_address,INSTR(email_address, '@')+1);
		            END IF;
              ELSE
            domain_name := null;
        END IF;

RETURN domain_name;
END ;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_REVERSE(Str Varchar2)
RETURN varchar2
IS 
    len  NUMBER; 
    StrOut VARCHAR(300); 
BEGIN 

    len := Length(str); 
  
    -- here we starting a loop from max len to 1 
    FOR i IN REVERSE 1.. len LOOP 
        -- assigning the reverse string in str1                
        StrOut := StrOut 
                || Substr(Str, i, 1); 
    END LOOP; 


RETURN StrOut;
END FNC_REVERSE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_ADVANCED_REPLACE(Str Varchar2)
RETURN varchar2
as
    
   type namesarray IS VARRAY(47) OF VARCHAR2(500); 
   names namesarray;   
   StrOut varchar2(300);
BEGIN 
	
   StrOut:=Str;	
   names := namesarray('a','b','c','ç','d','e',
  'f','g','ğ','h','ı','i','j','k','l','m','n','o',
  'ö','p','q','r','s','ş','t','u','ü','v','w','x',
  'y','z','0','1','2','3','4','5','6','7','8','9','@','-','_','.'); 
   

   FOR i IN 1..names.count LOOP
    -- Replace each character from the VARRAY with an empty string
    StrOut := REPLACE(StrOut, names(i), '');
  END LOOP;
  


RETURN StrOut;
END FNC_ADVANCED_REPLACE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_GET_SUBDOMAIN(email_address Varchar2)
RETURN varchar2
IS 
        at_position NUMBER;
        dot_position NUMBER;
       subdomain_name varchar2(300);
        
BEGIN 

        at_position := INSTR(email_address, '@');
        
        -- Check if '@' symbol is found
        IF at_position > 0 THEN
		            -- Find the position of the first '.' after '@'
		            dot_position := INSTR(email_address, '.', at_position);
		            -- Check if '.' symbol is found		           
		            IF dot_position > 0 THEN
		                subdomain_name := SUBSTR(email_address,dot_position+1);
		            ELSE
		                subdomain_name := null;
		            END IF;
              ELSE
            subdomain_name := null;
        END IF;

RETURN subdomain_name;
END ;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_SEARCH_IN_TABLE(
    p_table_name   IN VARCHAR2,
    p_column_name  IN VARCHAR2,
    p_search_str   IN VARCHAR2
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    -- Use dynamic SQL to execute the query
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table_name ||
                      ' WHERE ' || p_column_name || ' = :search_str'
        INTO v_count
        USING p_search_str;

 
    RETURN v_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL; 
END FNC_SEARCH_IN_TABLE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_TRIM(v_input_string Varchar2)
RETURN varchar2
IS 
   
  v_output_string VARCHAR2(1000);
  v_prev_char      VARCHAR2(1000);
BEGIN 

	  v_output_string := '';

IF v_input_string IS NOT NULL THEN 	 
		  -- Loop through each character in the input string
		  FOR i IN 1..LENGTH(v_input_string)
		  LOOP
		    -- Get the current character
		    v_prev_char := SUBSTR(v_input_string, i, 1);
		
		    -- Append the character to the output string unless it's a space and the previous character was also a space
		    IF v_prev_char NOT IN (' ', CHR(9)) OR  (v_prev_char IN (' ', CHR(9)) AND LENGTH(v_output_string) = 0)  THEN       
		      v_output_string := v_output_string || v_prev_char;
		    END IF;
		  END LOOP;
END IF;

RETURN v_output_string;
END FNC_TRIM;

---------------------------------------------------FUNCTIONS AND DEFINITION TABLES END--------------------------------------

-----------------------------------------------JOB STEPS PROCEDURES---------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL_PRE_PROCESS(
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
    
    dbms_output.put_line('vEmail: '||vEmail||'in_email: '||in_email);
END ;

------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_EMAIL_DECOMPOSITION (
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

CREATE OR REPLACE procedure QLICK.PRC_EMAIL_VALIDATION
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

--------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.EMAIL_MAIN_PROCEDURE (
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
          dbms_output.put_line('mail is null check-Out dec_email_quality_detail_code = ' || dec_email_quality_detail_code );
          dbms_output.put_line('mail is null check-Out dec_cl_email = ' || dec_cl_email );
        
    END IF;	

    IF vEmail IS NOT NULL AND FNC_TRIM(vEmail) IS NOT NULL THEN
    
    -- Call PRC_EMAIL_PRE_PROCESS
    QLICK.PRC_EMAIL_PRE_PROCESS(vEmail, in_email);
	/*
    dbms_output.put_line('PRC_EMAIL_PRE_PROCESS-vEmail = ' || vEmail ); 
    dbms_output.put_line('PRC_EMAIL_PRE_PROCES-in_email = ' || in_email ); 
   */

    -- Call PRC_EMAIL_DECOMPOSITION
    QLICK.PRC_EMAIL_DECOMPOSITION(
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
    QLICK.PRC_EMAIL_VALIDATION(
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
    QLICK.PRC_EMAIL_CHECK_QUALITY(
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
   
   	END IF;

END;

-----------------------------------------------JOB STEPS PROCEDURES ENDS---------------------------------------------------------

---------------------------For Test----------------------

DECLARE 
dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
BEGIN
	EMAIL_MAIN_PROCEDURE('merıcTOZDUMAN@HOTMAIL.COM',dec_email_quality_detail_code,dec_cl_email);
    dbms_output.put_line('dec_email_quality_detail_code= '||dec_email_quality_detail_code);
    dbms_output.put_line('dec_cl_email= '||dec_cl_email);
END;

----------------------------------------------------------