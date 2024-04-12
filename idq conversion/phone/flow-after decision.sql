--10-exp_pars_alan_kodu
dec_dahili_no=dec_dahili_no
telno1_alankodu=IIF(LENGTH(RTRIM(LTRIM(dec_telefon_no1)))=10,SUBSTR(RTRIM(LTRIM(dec_telefon_no1)),1,3),'')
telno2_alankodu=IIF(LENGTH(RTRIM(LTRIM(dec_telefon_no2)))=10,SUBSTR(RTRIM(LTRIM(dec_telefon_no2)),1,3),'')
telno3_alankodu=IIF(LENGTH(RTRIM(LTRIM(dec_telefon_no3)))=10,SUBSTR(RTRIM(LTRIM(dec_telefon_no3)),1,3),'')
telno1=IIF(LENGTH(RTRIM(LTRIM(dec_telefon_no1)))=10,SUBSTR(RTRIM(LTRIM(dec_telefon_no1)),4,7),'')
telno2=IIF(LENGTH(RTRIM(LTRIM(dec_telefon_no2)))=10,SUBSTR(RTRIM(LTRIM(dec_telefon_no2)),4,7),'')
telno3=IIF(LENGTH(RTRIM(LTRIM(dec_telefon_no3)))=10,SUBSTR(RTRIM(LTRIM(dec_telefon_no3)),4,7),'')

--11-lbl_ref
lbl_telno1_alan_kodu=	10-exp_pars_alan_kodu.telno1_alankodu,dic_ALLIANZ_cep_alan_kod tablosunda geçiyorsa 'valid' yaz
Token_telno1_alan=	    10-exp_pars_alan_kodu.telno1_alankodu,dic_ALLIANZ_sabit_alan_kod tablosunda geçiyorsa 'valid' yaz
lbl_telno2_alan_kodu=	10-exp_pars_alan_kodu.telno2_alankodu,dic_ALLIANZ_cep_alan_kod tablosunda geçiyorsa 'valid' yaz
Token_telno2_alan=	    10-exp_pars_alan_kodu.telno2_alankodu,dic_ALLIANZ_sabit_alan_kod tablosunda geçiyorsa 'valid' yaz
lbl_telno3_alan_kodu=	10-exp_pars_alan_kodu.telno3_alankodu,dic_ALLIANZ_cep_alan_kod tablosunda geçiyorsa 'valid' yaz
Token_telno3_alan=	    10-exp_pars_alan_kodu.telno3_alankodu,dic_ALLIANZ_sabit_alan_kod tablosunda geçiyorsa 'valid' yaz
lbl_telno1=	            10-exp_pars_alan_kodu.telno1, dic_ALLIANZ_noise_tel de varsa 'invalid' yaz
Token_telno1=	        10-exp_pars_alan_kodu.telno1, dic_ALLIANZ_noise_tel de varsa 'invalid' yaz
lbl_telno2=	            10-exp_pars_alan_kodu.telno2, dic_ALLIANZ_noise_tel de varsa 'invalid' yaz
Token_telno2=	        10-exp_pars_alan_kodu.telno2, dic_ALLIANZ_noise_tel de varsa 'invalid' yaz
lbl_telno3=	            10-exp_pars_alan_kodu.telno3, dic_ALLIANZ_noise_tel de varsa 'invalid' yaz
Token_telno3=	        10-exp_pars_alan_kodu.telno3, dic_ALLIANZ_noise_tel de varsa 'invalid' yaz

--12-Exp_decision_after_label
telno1_alankodu=	10-exp_pars_alan_kodu.telno1_alankodu
telno2_alankodu=	10-exp_pars_alan_kodu.telno2_alankodu
telno3_alankodu=	10-exp_pars_alan_kodu.telno3_alankodu
telno1=				10-exp_pars_alan_kodu.telno1
telno2=				10-exp_pars_alan_kodu.telno2
telno3=				10-exp_pars_alan_kodu.telno3
in_dahili_no		10-exp_pars_alan_kodu.dec_dahili_no
lbl_telno1_alan_kodu=	11-lbl_ref.lbl_telno1_alan_kodu
lbl_telno2_alan_kodu=	11-lbl_ref.lbl_telno2_alan_kodu
lbl_telno3_alan_kodu=	11-lbl_ref.lbl_telno3_alan_kodu
lbl_telno1				11-lbl_ref.lbl_telno1
lbl_telno2				11-lbl_ref.lbl_telno2
lbl_telno3				11-lbl_ref.lbl_telno3
Telno_1	IIF(lbl_telno1_alankodu='valid' and lbl_telno1!='invalid', telno1_alankodu || telno1,'')
Telno_2	IIF(lbl_telno2_alankodu='valid' and lbl_telno2!='invalid', telno2_alankodu || telno2,'')
Telno_3	IIF(lbl_telno3_alankodu='valid' and lbl_telno3!='invalid', telno3_alankodu || telno3,'')

CREATE OR REPLACE PROCEDURE QLICK.MAIN_PHN_PROCESS(
    in_telefon_numarasi IN VARCHAR2,
    dec_dahili_no_out OUT VARCHAR2,
    telno1 OUT VARCHAR2,
    telno2 OUT VARCHAR2,
    telno3 OUT VARCHAR2
)
IS
    std_tel_no VARCHAR2(300);
    lbl_tel_no VARCHAR2(300);
    lbl_alan_kodu1 VARCHAR2(50);
    lbl_alan_kodu2 VARCHAR2(50);
    hat_flag NUMBER;
    dahili_flag NUMBER;
    dec_telefon_no1 VARCHAR2(300);
    dec_telefon_no2 VARCHAR2(300);
    dec_telefon_no3 VARCHAR2(300);
BEGIN
    -- trimliyoruz,özel karakterleri çıkatıyoruz. Rakamsal hali std_tel_no içinde xddddddd formatı lbl_tel_no içinde
    QLICK.PRC_PHN_PROCESS_NUMBER(in_telefon_numarasi, std_tel_no, lbl_tel_no);

    -- ev veya cep telefonu olduğunu kontrol ediyoruz
    QLICK.PRC_PHN_MOBILEHOME_CHCK(std_tel_no, lbl_alan_kodu1, lbl_alan_kodu2);

    -- dahili veya normal hat mı kontrolu yapıyoruz
    QLICK.PRC_PHN_EXTENSION_CHCK(in_telefon_numarasi, hat_flag, dahili_flag);

    -- yukarıdaki format vef flaglere göre telefon numarasının doğru formatına karar veriliyor
    QLICK.PRC_PHN_DECISION(lbl_tel_no, std_tel_no, lbl_alan_kodu1, lbl_alan_kodu2, dahili_flag, hat_flag, dec_telefon_no1, dec_telefon_no2, dec_telefon_no3, dec_dahili_no_out);

    -- nihai telefon tablosunun alan kodu, alan kod tablolarında, alan kod haric kısmıda noise tablosunda var mı check edilir.
    QLICK.PRC_PHN_VALIDATION(dec_dahili_no_out, dec_telefon_no1, dec_telefon_no2, dec_telefon_no3, dec_dahili_no_out, telno1, telno2, telno3);
END MAIN_PHN_PROCESS;
/
