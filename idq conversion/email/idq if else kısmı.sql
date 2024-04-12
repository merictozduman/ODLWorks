// Email verisi boş olmamalıdır
IF ISNULL(in_email)=1 OR LENGTH(in_email)=0
    THEN
       
    dec_email_quality_detail_code := '-' || 'genbos00'

ENDIF

// "@, -, _, ." işaretleri ve harf rakam karakterleri dışındaki diğer karakterler olmamalıdır						
IF exp_undefined_character_length>0
    THEN
       
    dec_email_quality_detail_code :=dec_email_quality_detail_code|| '-' || 'emlgec01'

ENDIF

// "@, -, _, ." işaretlerinin çıkartılmasından sonra, uzunluğu 5 karaktere eşit ve az olmamalıdır											
IF exp_email_without_symbol_length<=5
    THEN
       
    dec_email_quality_detail_code :=dec_email_quality_detail_code|| '-' || 'emlgec02'

ENDIF

// Email verisi içinde kullanıcı adı uzunluğu 2 karaktere  az olmamalıdır					
IF exp_email_user_name<2 AND exp_email_character_first_order>0
    THEN
       
    dec_email_quality_detail_code :=dec_email_quality_detail_code|| '-' || 'emlgec05'

ENDIF

// Email kullanıcı adı bilgisi sadece referans kütüphanesinde belirtilen kelimelerden oluşmamalıdır.		
IF tkn_username_noise='valid'
    THEN
       
    dec_email_quality_detail_code :=dec_email_quality_detail_code|| '-' || 'emlgec06'

ENDIF

// E-Mail verisi içinde ‘@’ karakteri bulunmalıdır										
IF exp_email_character_first_order=0
    THEN
       
    dec_email_quality_detail_code :=dec_email_quality_detail_code|| '-' || 'emlgec07'

ENDIF

// E-Mail alt domain uzantısı bilgisi (com, com.tr v.b.) geçerli kayıt referans kütüphanesinde yer almalıdır					
IF tkn_subdomain_pattern<>'valid'
    THEN
       
    dec_email_quality_detail_code :=dec_email_quality_detail_code|| '-' || 'emlprb09'

ENDIF

//Sonuç
IF dec_email_quality_detail_code=''
    THEN

	dec_email_quality_detail_code	:= 'genkal00'
	dec_cl_email := in_email

ELSE

	dec_email_quality_detail_code := SUBSTR(dec_email_quality_detail_code,2,LENGTH(dec_email_quality_detail_code)-1)
	dec_cl_email :=''
ENDIFl

DECLARE
var1 varchar2(300);
var2 varchar2(300);
BEGIN
	PKG_EMAIL_PROCESS.MAIN_EMAIL_PROCESS('merictozduman@hotmail.com',var1,var2);
    dbms_output.put_line(var1||'   '||var2);
END;
