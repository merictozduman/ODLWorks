/************************************************************FONKSIYON TANIMLARI******************************************************************/

CREATE OR REPLACE FUNCTION FNC_EMAIL_ISVALID(
    p_mail IN VARCHAR2
) RETURN NUMBER
AS
dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
BEGIN

	PRC_EMAIL_MAIN_PROCEDURE(p_mail,dec_email_quality_detail_code,dec_cl_email);
    IF dec_email_quality_detail_code='genkal00' OR (dec_cl_email IS NOT NULL AND dec_cl_email!='') THEN
    	RETURN 1;
    ELSE 
        RETURN 0;
    END IF;   
END FNC_EMAIL_ISVALID;

CREATE OR REPLACE FUNCTION FNC_EMAIL_QUALITY_CODE(
    p_mail IN VARCHAR2
) RETURN VARCHAR
AS
dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
BEGIN

	PRC_EMAIL_MAIN_PROCEDURE(p_mail,dec_email_quality_detail_code,dec_cl_email);
    RETURN dec_email_quality_detail_code; 
END FNC_EMAIL_QUALITY_CODE;

CREATE OR REPLACE FUNCTION FNC_EMAIL_PROCESSED(
    p_mail IN VARCHAR2
) RETURN VARCHAR
AS
dec_email_quality_detail_code varchar2(300);
dec_cl_email varchar2(300);
BEGIN

	PRC_EMAIL_MAIN_PROCEDURE(p_mail,dec_email_quality_detail_code,dec_cl_email);
    RETURN dec_cl_email; 
END FNC_EMAIL_PROCESSED;

CREATE OR REPLACE FUNCTION FNC_PHN_DAHILI(
    in_telefon_numarasi IN VARCHAR2
) RETURN VARCHAR2
AS
    dec_dahili_no_out VARCHAR2(300);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN

	PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);
    	RETURN NVL(dec_dahili_no_out,'YOK');
END FNC_PHN_DAHILI;

CREATE OR REPLACE FUNCTION FNC_PHN_ISVALID(
    in_telefon_numarasi IN VARCHAR2
) RETURN NUMBER
AS
    dec_dahili_no_out VARCHAR2(300);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN

	PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);
    IF (dec_dahili_no_out=''  AND  telno1='' AND telno2='' AND telno3='' ) OR 
       (dec_dahili_no_out IS NULL  AND  telno1 IS NULL AND telno2 IS NULL AND telno3 IS NULL)
    THEN
    	RETURN 0;
    ELSE 
        RETURN 1;
    END IF;   
END FNC_PHN_ISVALID;

CREATE OR REPLACE FUNCTION FNC_PHN_TELNO1(
    in_telefon_numarasi IN VARCHAR2
) RETURN VARCHAR2
AS
    dec_dahili_no_out VARCHAR2(300);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN

	PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);
    	RETURN NVL(telno1,'YOK');
END FNC_PHN_TELNO1;

CREATE OR REPLACE FUNCTION FNC_PHN_TELNO2(
    in_telefon_numarasi IN VARCHAR2
) RETURN VARCHAR2
AS
    dec_dahili_no_out VARCHAR2(300);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN

	PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);
    	RETURN NVL(telno2,'YOK');
END FNC_PHN_TELNO2;

CREATE OR REPLACE FUNCTION FNC_PHN_TELNO3(
    in_telefon_numarasi IN VARCHAR2
) RETURN VARCHAR2
AS
    dec_dahili_no_out VARCHAR2(300);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN

	PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);
    	RETURN NVL(telno3,'YOK');
END FNC_PHN_TELNO3;



/************************************************************KULLANIM ORNEKLERI******************************************************************/


--------------------------------------------------------EMAIL FONKSIYONLAR-------------------------------------------------------------------------

-- valid bir email ise 1 döndürür. Valid değilse 0 döndürür
SELECT FNC_EMAIL_ISVALID('MERICTOZDUMAN@HOTMAIL.COM') FROM DUAL  

--girilen email'in quality code'unu döndürür. Yaklaşık on tane kod var. genkal00 valid mail adresi demek.
SELECT FNC_EMAIL_QUALITY_CODE('N@HOTMAIL.COM') FROM DUAL

--hataları düzeltilebilirse, düzeltilmiş ve valid edilmiş mail adresini döndürür
SELECT FNC_EMAIL_PROCESSED('MERICTOZDUMAN@HOTMAIL.COM') FROM DUAL

---------------------------------------------------------TEL FONKSIYONLAR--------------------------------------------------------------------------


--dahili no'yu döndürür. dahili içermiyorsa 'YOK' döndürür.
SELECT FNC_PHN_DAHILI('05311016093') FROM dual

-- valid bir tel ise 1 döndürür. Valid değilse 0 döndürür
SELECT FNC_PHN_ISVALID('05311016093') FROM DUAL

--Çok uzun bir tel değeri girildiyse, içinden iki telefon çıkartabiliyor. İlk çıkarılan tel no.Geçersiz veya yoksa 'YOK' döndürür.
SELECT FNC_PHN_TELNO1('05311016093') FROM DUAL

--Çok uzun bir tel değeri girildiyse, içinden iki telefon çıkartabiliyor. İlk çıkarılan tel no.Geçersiz veya yoksa 'YOK' döndürür.
SELECT FNC_PHN_TELNO2('05311016093') FROM DUAL

--Çok uzun bir tel değeri girildiyse, içinden iki telefon çıkartabiliyor. İlk çıkarılan tel no.Geçersiz veya yoksa 'YOK' döndürür.
SELECT FNC_PHN_TELNO3('05311016093') FROM DUAL

FNC_EMAIL_PROCESSED()
FNC_EMAIL_QUALITY_CODE()

FNC_EMAIL_PROCESSED() AS emailaddress1_processed,
FNC_EMAIL_QUALITY_CODE() AS emailaddress1_quality_code,

FNC_EMAIL_PROCESSED() AS cdvemailinfo_processed,
FNC_EMAIL_QUALITY_CODE() AS cdvemailinfo_quality_code,

FNC_PHN_DAHILI() 
FNC_PHN_TELNO1() 
FNC_PHN_TELNO2() 
FNC_PHN_TELNO3() 

FNC_PHN_DAHILI() AS mobilephone_dahili,
FNC_PHN_TELNO1() AS mobilephone_telno1,
FNC_PHN_TELNO2() AS mobilephone_telno2,
FNC_PHN_TELNO3() AS mobilephone_telno3,

FNC_PHN_DAHILI() AS telephone3_dahili,
FNC_PHN_TELNO1() AS telephone3_telno1,
FNC_PHN_TELNO2() AS telephone3_telno2,
FNC_PHN_TELNO3() AS telephone3_telno3,

FNC_PHN_DAHILI() AS cdvgsminfo_dahili,
FNC_PHN_TELNO1() AS cdvgsminfo_telno1,
FNC_PHN_TELNO2() AS cdvgsminfo_telno2,
FNC_PHN_TELNO3() AS cdvgsminfo_telno3,

grant execute on composecrml1.FNC_PHN_DAHILI to compose
grant execute on composecrml1.FNC_PHN_TELNO1 to compose
grant execute on composecrml1.FNC_PHN_TELNO2 to compose
grant execute on composecrml1.FNC_PHN_TELNO3 to compose

grant execute on composecrml1.FNC_EMAIL_PROCESSED to compose
grant execute on composecrml1.FNC_EMAIL_QUALITY_CODE to compose