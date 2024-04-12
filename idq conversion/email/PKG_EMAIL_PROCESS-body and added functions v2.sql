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

CREATE OR REPLACE PACKAGE BODY QLICK.PKG_EMAIL_PROCESS AS
	
	  FUNCTION FNC_ADVANCED_REPLACE(Str VARCHAR2) RETURN VARCHAR2 IS
			    TYPE namesarray IS VARRAY(47) OF VARCHAR2(500);
			    names namesarray;
			    StrOut VARCHAR2(300);
			  BEGIN
			    StrOut := Str;
			    names := namesarray('a','b','c','ç','d','e',
			                        'f','g','ğ','h','ı','i','j','k','l','m','n','o',
			                        'ö','p','q','r','s','ş','t','u','ü','v','w','x',
			                        'y','z','0','1','2','3','4','5','6','7','8','9','@','-','_','.');
			
			    FOR i IN 1..names.COUNT LOOP
			      StrOut := REPLACE(StrOut, names(i), '');
			    END LOOP;
			
			    RETURN StrOut;
	  END FNC_ADVANCED_REPLACE;
	
	  FUNCTION FNC_REVERSE(Str VARCHAR2) RETURN VARCHAR2 IS
			    len NUMBER;
			    StrOut VARCHAR(300);
			  BEGIN
			    len := LENGTH(Str);
			
			    FOR i IN REVERSE 1..len LOOP
			      StrOut := StrOut || SUBSTR(Str, i, 1);
			    END LOOP;
			
			    RETURN StrOut;
	  END FNC_REVERSE;
	
	  FUNCTION FNC_TRIM(Str VARCHAR2) RETURN VARCHAR2 IS
			    StrOut VARCHAR(300);
			   BEGIN
			    StrOut := REPLACE(REPLACE(Str, ' ', ''), '	', '');
			
			    RETURN StrOut;
	  END FNC_TRIM;
	
PROCEDURE PRC_EMAIL_STEP2(vEmail IN Varchar2,in_email OUT varchar2)
IS 
vStgEmailReturn varchar2(250);
BEGIN 
	
--2-std STEP'ine aittir.
	
    vStgEmailReturn:=FNC_TRIM(vEmail);

    vStgEmailReturn:=replace(vStgEmailReturn,'@@','@');
    vStgEmailReturn:=replace(vStgEmailReturn,',@','@');   
    vStgEmailReturn:=replace(vStgEmailReturn,'HOTMAIL','HOTMAIL.COM');
    vStgEmailReturn:=replace(vStgEmailReturn,'HOTMAİL','HOTMAIL.COM');
	vStgEmailReturn:=replace(vStgEmailReturn,'HOTMAİLCOM','HOTMAIL.COM');
	vStgEmailReturn:=replace(vStgEmailReturn,'HOTMAILCOM','HOTMAIL.COM');
	vStgEmailReturn:=replace(vStgEmailReturn,'GMAİL','GMAIL.COM');
	vStgEmailReturn:=replace(vStgEmailReturn,'.coom','.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'superonline','superonline.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'yahoo','yahoo.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'mynet','mynet.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'gmail','gmail.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'hotmail','hotmail.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'gmail','gmail.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'hotmailcom','hotmail.com');
	vStgEmailReturn:=replace(vStgEmailReturn,'ş','s');
	vStgEmailReturn:=replace(vStgEmailReturn,'Ş','s');
	vStgEmailReturn:=replace(vStgEmailReturn,'ü','u');
	vStgEmailReturn:=replace(vStgEmailReturn,'Ü','u');
	vStgEmailReturn:=replace(vStgEmailReturn,'ğ','g');
	vStgEmailReturn:=replace(vStgEmailReturn,'Ğ','g');
	vStgEmailReturn:=replace(vStgEmailReturn,'ö','o');
	vStgEmailReturn:=replace(vStgEmailReturn,'Ö','o');
	vStgEmailReturn:=replace(vStgEmailReturn,'ı','i');
	vStgEmailReturn:=replace(vStgEmailReturn,'İ','i');
	vStgEmailReturn:=replace(vStgEmailReturn,'ç','c');
	vStgEmailReturn:=replace(vStgEmailReturn,'Ç','c');
	vStgEmailReturn:=replace(vStgEmailReturn,'comtr','com.tr');
	vStgEmailReturn:=replace(vStgEmailReturn,'com.com','com');--Ben ekledim.MT.
	vStgEmailReturn:=replace(vStgEmailReturn,'COM.COM','COM');--Ben ekledim.MT.

in_email:=vStgEmailReturn   ;


END PRC_EMAIL_STEP2;


Procedure PRC_EMAIL_STEP3_1
   ( vEmailStep2 IN varchar2, var_email_lower  OUT varchar2, var_domain_lower OUT varchar2,var_email_reverse OUT varchar2)
IS

BEGIN	
	--3-exp_domain step'ine aittir.

var_email_lower := LOWER(vEmailStep2);
--var_domain_lower = SUBSTR(LOWER(in_email), INSTR(in_email,'@')+1,INSTR(SUBSTR(LOWER(in_email,'@')+1),'.')-1) --Calismadi yenisini yazdim

IF fnc_get_domain(vEmailStep2) IS NULL THEN 
var_domain_lower:=NULL ;
else
var_domain_lower:=LOWER(fnc_get_domain(vEmailStep2));
END if;

var_email_reverse := FNC_REVERSE(LOWER(vEmailStep2));
   
end  PRC_EMAIL_STEP3_1;

Procedure PRC_EMAIL_STEP3_2
   ( var_email_lower  IN varchar2, 
     var_domain_lower IN varchar2,
     var_email_reverse IN varchar2,
	     exp_undefined_character OUT varchar2,
	     exp_email_subdomain OUT varchar2,
	     exp_email_lower OUT varchar2,
	     exp_email_user_name OUT varchar2
     )
IS

BEGIN	
	--3-exp_domain step'ine aittir.

     exp_undefined_character :=FNC_ADVANCED_REPLACE(var_email_lower)||FNC_ADVANCED_REPLACE(var_domain_lower);
     exp_email_subdomain :=FNC_GET_SUBDOMAIN(var_email_lower); --subdomain tespiti yanlış. hotmail.com da com u veriyor
     exp_email_lower := var_email_lower;
     exp_email_user_name :=SUBSTR(var_email_lower , 1 , INSTR(var_email_lower,'@',1,1)-1);
   
end PRC_EMAIL_STEP3_2;

procedure PRC_EMAIL_STEP4
   ( 
   exp_email_subdomain IN varchar2,
   exp_email_user_name IN varchar2,
   exp_email_lower IN VARCHAR2,
    Tkn_subdomain_pattern OUT varchar2, 
    TokenizedData2 OUT varchar2,
    Tkn_username_noise OUT varchar2,
	tokenizedData5 OUT varchar2,
	std_email_without_symbol OUT varchar2
     )
IS

StrStgDomain varchar2(300);
StrStgNoise varchar2(300);

BEGIN
	--4-Std Turkish&Tkn Pattern step'ine aittir.
	
-------------------------------Tkn Pattern START-------------------------------------	

SELECT decode((SELECT email_domain 
						FROM REF_EMAIL_DOMAIN 
						where email_domain=exp_email_subdomain),
						NULL,'invalid','valid') 
INTO StrStgDomain 
FROM dual;


SELECT decode((SELECT email_noise
						FROM qlick.ref_email_noise 
						where email_noise=exp_email_user_name),
						NULL,'invalid','valid') 
INTO  StrStgNoise 
FROM dual;


--StrStgDomain:='valid';
--StrStgNoise:='valid';

  IF StrStgDomain='valid' THEN
  		Tkn_subdomain_pattern:='valid';
  ELSE    
        TokenizedData2:='invalid';
       Tkn_subdomain_pattern:='invalid';
  END IF;      

  IF StrStgNoise='valid' THEN
  		Tkn_username_noise:='valid';
  ELSE    
        tokenizedData5:='invalid';
       Tkn_username_noise:='invalid';
  END IF;      
 
 -------------------------------Tkn Pattern END-------------------------------------
 -----------------------------------------------------------------------------------
 ------------------------------STD Turkish Start------------------------------------

 std_email_without_symbol:=REPLACE(REPLACE(REPLACE(REPLACE(exp_email_lower,'@',''),'-',''),'.',''),'_','');
 
  ------------------------------STD Turkish END-----------------------------------    
end PRC_EMAIL_STEP4;

PROCEDURE PRC_EMAIL_STEP5_1(
vEmail IN Varchar2,
var_email_character_first_order OUT number)

IS 
vStgEmailReturn varchar2(250);

BEGIN 	
--5-Exp_Measure STEP'ine aittir.	
    vStgEmailReturn:=FNC_TRIM(vEmail);

var_email_character_first_order:= INSTR(vStgEmailReturn,'@')   ;

END PRC_EMAIL_STEP5_1 ;

Procedure PRC_EMAIL_STEP5_2
   ( 
exp_undefined_character in varchar2,
std_email_without_symbol in varchar2,
in_email in varchar2,
var_email_character_first_order in number,
		exp_undefined_character_length out number,
		exp_email_without_symbol_length out number,
		exp_email_user_name out number,
		exp_email_character_first_order out number
     )
IS

BEGIN
--5-Exp_Measure step'ine aittir.
	
exp_undefined_character_length := LENGTH(exp_undefined_character);

exp_email_without_symbol_length := LENGTH(std_email_without_symbol); 

exp_email_user_name := LENGTH(SUBSTR(in_email,1,var_email_character_first_order-1));

exp_email_character_first_order:=var_email_character_first_order;

end PRC_EMAIL_STEP5_2;	

PROCEDURE CHECK_EMAIL_QUALITY(
    in_email IN VARCHAR2,
    exp_undefined_character_length IN NUMBER,
    exp_email_without_symbol_length IN NUMBER,
    exp_email_user_name IN number,
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
    IF exp_email_user_name < 2 AND exp_email_character_first_order > 0 THEN
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
   
END CHECK_EMAIL_QUALITY;

PROCEDURE MAIN_EMAIL_PROCESS(
    vEmail IN VARCHAR2,
    dec_email_quality_detail_code OUT VARCHAR2,
    dec_cl_email OUT VARCHAR2
) AS
    in_email VARCHAR2(300);
    var_email_lower VARCHAR2(300);
    var_domain_lower VARCHAR2(300);
    var_email_reverse VARCHAR2(300);
    exp_undefined_character VARCHAR2(300);
    exp_email_subdomain VARCHAR2(300);
    exp_email_lower VARCHAR2(300);
    exp_email_user_name VARCHAR2(300);
    Tkn_subdomain_pattern VARCHAR2(300);
    TokenizedData2 VARCHAR2(300);
    Tkn_username_noise VARCHAR2(300);
    tokenizedData5 VARCHAR2(300);
    std_email_without_symbol VARCHAR2(300);
    var_email_character_first_order NUMBER;
    exp_undefined_character_length NUMBER;
    exp_email_without_symbol_length NUMBER;

BEGIN

    IF vEmail IS NULL OR FNC_TRIM(vEmail) IS NULL THEN
          dec_email_quality_detail_code := 'genbos00';
          dec_cl_email := '';
          dbms_output.put_line('mail is null check-Out dec_email_quality_detail_code = ' || dec_email_quality_detail_code );
          dbms_output.put_line('mail is null check-Out dec_cl_email = ' || dec_cl_email );
        
    END IF;	

    IF vEmail IS NOT NULL AND FNC_TRIM(vEmail) IS NOT NULL THEN
  
    -- Call the procedures in order
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP2(vEmail, in_email);
    
    dbms_output.put_line('PRC_EMAIL_STEP2-In vEmail = ' || vEmail ); 
    dbms_output.put_line('PRC_EMAIL_STEP2-Out in_email = ' || in_email ); 
    
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP3_1(in_email, var_email_lower, var_domain_lower, var_email_reverse);
     
    dbms_output.put_line('PRC_EMAIL_STEP3_1-In in_email = ' || in_email );
    dbms_output.put_line('PRC_EMAIL_STEP3_1-Out var_email_lower = ' || var_email_lower ); 
    dbms_output.put_line('PRC_EMAIL_STEP3_1-Out var_domain_lower = ' || var_domain_lower ); 
    dbms_output.put_line('PRC_EMAIL_STEP3_1-Out var_email_reverse = ' || var_email_reverse ); 
    
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP3_2(var_email_lower, var_domain_lower, var_email_reverse,
                                        exp_undefined_character, exp_email_subdomain,
                                        exp_email_lower, exp_email_user_name);

	dbms_output.put_line('PRC_EMAIL_STEP3_2-In var_email_lower = ' || var_email_lower );
    dbms_output.put_line('PRC_EMAIL_STEP3_2-In var_domain_lower = ' || var_domain_lower );
    dbms_output.put_line('PRC_EMAIL_STEP3_2-In var_email_reverse = ' || var_email_reverse );
	
	dbms_output.put_line('PRC_EMAIL_STEP3_2-Out exp_undefined_character = ' || exp_undefined_character );
	dbms_output.put_line('PRC_EMAIL_STEP3_2-Out exp_email_subdomain = ' || exp_email_subdomain );
	dbms_output.put_line('PRC_EMAIL_STEP3_2-Out exp_email_lower = ' || exp_email_lower );
	dbms_output.put_line('PRC_EMAIL_STEP3_2-Out exp_email_user_name = ' || exp_email_user_name ); 
                                       
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP4(exp_email_subdomain, exp_email_user_name, exp_email_lower,
                                        Tkn_subdomain_pattern, TokenizedData2,
                                        Tkn_username_noise, tokenizedData5,
                                        std_email_without_symbol);

	dbms_output.put_line('PRC_EMAIL_STEP4-In exp_email_subdomain = ' || exp_email_subdomain);
	dbms_output.put_line('PRC_EMAIL_STEP4-In exp_email_user_name = ' || exp_email_user_name);
	dbms_output.put_line('PRC_EMAIL_STEP4-In exp_email_lower = ' || exp_email_lower );
	
	dbms_output.put_line('PRC_EMAIL_STEP4-Out Tkn_subdomain_pattern = ' || Tkn_subdomain_pattern ); 
	dbms_output.put_line('PRC_EMAIL_STEP4-Out TokenizedData2 = ' || TokenizedData2 ); 
	dbms_output.put_line('PRC_EMAIL_STEP4-Out Tkn_username_noise = ' || Tkn_username_noise ); 
	dbms_output.put_line('PRC_EMAIL_STEP4-Out tokenizedData5 = ' || tokenizedData5 ); 
	dbms_output.put_line('PRC_EMAIL_STEP4-Out std_email_without_symbol = ' || std_email_without_symbol ); 

    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP5_1(in_email, var_email_character_first_order);

  	dbms_output.put_line('PRC_EMAIL_STEP5_1-In in_email = ' || in_email );

	dbms_output.put_line('PRC_EMAIL_STEP5_1-Out var_email_character_first_order = ' || var_email_character_first_order );  
  
    PKG_EMAIL_PROCESS.PRC_EMAIL_STEP5_2(exp_undefined_character, std_email_without_symbol, in_email,
                                        var_email_character_first_order, exp_undefined_character_length,
                                        exp_email_without_symbol_length, exp_email_user_name,
                                        var_email_character_first_order);

dbms_output.put_line('PRC_EMAIL_STEP5_2-In exp_undefined_character = ' || exp_undefined_character );
dbms_output.put_line('PRC_EMAIL_STEP5_2-In std_email_without_symbol = ' || std_email_without_symbol );
dbms_output.put_line('PRC_EMAIL_STEP5_2-In in_email = ' || in_email );
dbms_output.put_line('PRC_EMAIL_STEP5_2-In var_email_character_first_order = ' || var_email_character_first_order );

dbms_output.put_line('PRC_EMAIL_STEP5_2-Out exp_undefined_character_length = ' || exp_undefined_character_length ); 
dbms_output.put_line('PRC_EMAIL_STEP5_2-Out exp_email_without_symbol_length = ' || exp_email_without_symbol_length ); 
dbms_output.put_line('PRC_EMAIL_STEP5_2-Out exp_email_user_name = ' || exp_email_user_name ); 
dbms_output.put_line('PRC_EMAIL_STEP5_2-Out var_email_character_first_order = ' || var_email_character_first_order ); 

    PKG_EMAIL_PROCESS.CHECK_EMAIL_QUALITY(in_email, exp_undefined_character_length,
                                         exp_email_without_symbol_length, exp_email_user_name,
                                         var_email_character_first_order, Tkn_username_noise,
                                         Tkn_subdomain_pattern, dec_email_quality_detail_code,
                                         dec_cl_email);

dbms_output.put_line('CHECK_EMAIL_QUALITY-In in_email = ' || in_email );
dbms_output.put_line('CHECK_EMAIL_QUALITY-In exp_undefined_character_length = ' || exp_undefined_character_length );
dbms_output.put_line('CHECK_EMAIL_QUALITY-In exp_email_without_symbol_length = ' || exp_email_without_symbol_length );
dbms_output.put_line('CHECK_EMAIL_QUALITY-In exp_email_user_name = ' || exp_email_user_name);
dbms_output.put_line('CHECK_EMAIL_QUALITY-In var_email_character_first_order = ' || var_email_character_first_order );
dbms_output.put_line('CHECK_EMAIL_QUALITY-In Tkn_username_noise = ' || Tkn_username_noise );
dbms_output.put_line('CHECK_EMAIL_QUALITY-In Tkn_subdomain_pattern = ' || Tkn_subdomain_pattern );

dbms_output.put_line('CHECK_EMAIL_QUALITY-Out dec_email_quality_detail_code = ' || dec_email_quality_detail_code );
dbms_output.put_line('CHECK_EMAIL_QUALITY-Out dec_cl_email = ' || dec_cl_email );

	END IF;

END MAIN_EMAIL_PROCESS;


END PKG_EMAIL_PROCESS;

