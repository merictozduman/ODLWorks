create table COMPOSECRML1.mt_test_sil as
select phone from COMPOSECRML1.MDM_CRM_PHN_STACK
where 1=2

create table COMPOSECRML1.mt_test_sil2 as
SELECT EMAILADDRESS FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK
where 1=2

insert /*+append*/ into COMPOSECRML1.mt_test_sil
select mobilephone as phone from composecrml1.tdwh_crm_abs_comm_raw_hub ab
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where ab.mobilephone=mrm.phone)
union
select telephone3 as phone  from composecrml1.tdwh_crm_abs_comm_raw_hub ab2
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where ab2.telephone3=mrm.phone)
union
select mobilephone as phone from composecrml1.tdwh_crm_azs_comm_raw_hub  azs1
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azs1.mobilephone=mrm.phone)
union
select telephone3 as phone from composecrml1.tdwh_crm_azs_comm_raw_hub  azs2
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azs2.telephone3=mrm.phone)
union 
select telephone3 as phone from composecrml1.tdwh_crm_yasam_comm_raw_hub yas
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where yas.telephone3=mrm.phone)


INSERT INTO COMPOSECRML1.mt_test_sil2 EMAILADDRESS 
SELECT emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_azs_comm_raw_hub 
UNION
SELECT emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_abs_comm_raw_hub 
UNION
SELECT emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_yasam_comm_raw_hub 

DECLARE
    v_chunk_size CONSTANT NUMBER := 10000;
    v_phone_number VARCHAR2(50);
    v_counter NUMBER := 0;
    v_cnt_total NUMBER; 

BEGIN
  sELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.mt_test_sil;
    FOR rec IN (SELECT PHONE AS phone_number FROM COMPOSECRML1.mt_test_sil) LOOP
        v_counter := v_counter + 1;
        if rec.phone_number is not null or rec.phone_number!='' THEN
                DECLARE
                    v_dec_dahili_no VARCHAR2(300);
                    v_telno1 VARCHAR2(300);
                    v_telno2 VARCHAR2(300);
                    v_telno3 VARCHAR2(300);
                BEGIN
                    PRC_PHN_MAIN_PROCESS(
                        rec.phone_number,
                        v_dec_dahili_no,
                        v_telno1,
                        v_telno2,
                        v_telno3
                    );
                END;
         end if;       
        -- Check if the chunk size is reached or it's the last iteration
        IF MOD(v_counter, v_chunk_size) = 0 OR v_counter = v_cnt_total THEN
            COMMIT;
          --  dbms_output.put_line('v_counter: '||v_counter);
        END IF;
    END LOOP;
END;

DECLARE
    v_chunk_size CONSTANT NUMBER := 10000;
    v_phone_number VARCHAR2(50);
    v_counter NUMBER := 0;
    v_cnt_total NUMBER; 

BEGIN
  sELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.mt_test_sil2 ;
    FOR rec IN (SELECT EMAILADDRESS AS EMAILADDRESS  FROM COMPOSECRML1.mt_test_sil2 ) LOOP
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


-----------------------------------------------------------CALISMA SCRIPTLERI-------------------------------------------------------------------

select count(*) from COMPOSECRML1.MDM_CRM_PHN_STACK

select count(*) from  COMPOSECRML1.MDM_CRM_EMAIL_STACK

select * from MDM_CRM_PHN_STACK

select *
from COMPOSECRML1.mt_test_sil
WHERE PHONE IS NULL

select EMAILADDRESS from COMPOSECRML1.mt_test_sil2
MINUS
SELECT EMAILADDRESS FROM MDM_CRM_EMAIL_STACK


SELECT TRIM(EMAILADDRESS) FROM MDM_CRM_EMAIL_STACK
MINUS
select TRIM(EMAILADDRESS) from COMPOSECRML1.mt_test_sil2

SELECT TRIM(EMAILADDRESS) FROM COMPOSECRML1.mt_test_sil2

SELECT COUNT(*),COUNT(DISTINCT EMAILADDRESS) FROM COMPOSECRML1.mt_test_sil2
select count(*) from MDM_CRM_EMAIL_STACK

SELECT * FROM  MDM_CRM_EMAIL_STACK
WHERE EMAILADDRESS LIKE '%--fikret.alp@hotmail.com%'

SELECT * FROM COMPOSECRML1.mt_test_sil2
WHERE EMAILADDRESS LIKE '%--fikret.alp@hotmail.com%'

TRUNCATE TABLE MDM_CRM_EMAIL_STACK


4868380

insert /*+append*/ into COMPOSECRML1.mt_test_sil
select TRIM(mobilephone) as phone from composecrml1.tdwh_crm_abs_comm_raw_hub ab
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where ab.mobilephone=mrm.phone)
union
select telephone3 as phone  from composecrml1.tdwh_crm_abs_comm_raw_hub ab2
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where ab2.telephone3=mrm.phone)
union
select mobilephone as phone from composecrml1.tdwh_crm_azs_comm_raw_hub  azs1
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azs1.mobilephone=mrm.phone)
union
select telephone3 as phone from composecrml1.tdwh_crm_azs_comm_raw_hub  azs2
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azs2.telephone3=mrm.phone)
union 
select telephone3 as phone from composecrml1.tdwh_crm_yasam_comm_raw_hub yas
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where yas.telephone3=mrm.phone)

commit

select count(*) from COMPOSECRML1.mt_test_sil

insert /*+append*/ into COMPOSECRML1.mt_test_sil
select MOBILEPHONE as phone from COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB azshe
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azshe.MOBILEPHONE=mrm.phone)
union
select TELEPHONE3 as phone  from COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB azshe
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azshe.TELEPHONE3=mrm.phone)

insert /*+append*/ into COMPOSECRML1.mt_test_sil
select CDVGSMINFO as phone  from COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB azshe
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azshe.CDVGSMINFO=mrm.phone)
union
select CDVGSMINFO as phone  from composecrml1.tdwh_crm_abs_comm_raw_hub abs1
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where abs1.CDVGSMINFO=mrm.phone)
union
select CDVGSMINFO as phone  from composecrml1.tdwh_crm_azs_comm_raw_hub azs
where not exists (select 1 from MDM_CRM_PHN_STACK mrm where azs.CDVGSMINFO=mrm.phone)

select count(*) from COMPOSECRML1.mt_test_sil2

insert /*+append*/ into COMPOSECRML1.mt_test_sil2
SELECT EMAILADDRESS1 FROM COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB azshe
where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azshe.Emailaddress1=mrm.EMAILADDRESS)
UNION 
SELECT Cdvemailinfo FROM COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB azshe
where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azshe.Cdvemailinfo=mrm.EMAILADDRESS)
union
SELECT Cdvemailinfo FROM composecrml1.tdwh_crm_azs_comm_raw_hub  azs
where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azs.Cdvemailinfo=mrm.EMAILADDRESS)
union
SELECT Cdvemailinfo FROM composecrml1.tdwh_crm_abs_comm_raw_hub abs1
where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where abs1.Cdvemailinfo=mrm.EMAILADDRESS)



SELECT DELTA_VALUE_KEY , 'HAYAT' SOURCE_SYSTEM, MOBILEPHONE,TELEPHONE3 
       , EMAILADDRESS1 ,CDVGSMINFO,  CDVEMAILINFO   
FROM COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB


TRUNCATE TABLE COMPOSECRML1.mt_test_sil2  

INSERT INTO COMPOSECRML1.mt_test_sil2  
SELECT emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_azs_comm_raw_hub 
UNION
SELECT emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_abs_comm_raw_hub 
UNION
SELECT emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_yasam_comm_raw_hub 

select * from  composecrml1.tdwh_crm_abs_comm_raw_hub  


--53,775,912   8,908,910 3,137,152
select count(*),count(distinct mobilephone),count(distinct telephone3) from composecrml1.tdwh_crm_yasam_comm_raw_hub 

select count(*),count(distinct mobilephone),count(distinct telephone3) from composecrml1.tdwh_crm_abs_comm_raw_hub 

select count(*),count(distinct mobilephone),count(distinct telephone3) from composecrml1.tdwh_crm_azs_comm_raw_hub 


select * from composecrml1.tdwh_crm_yasam_comm_raw_hub 



select y.delta_value_key, 'YASAM' source_system, y.mobilephone, y.telephone3, y.emailaddress1 from composecrml1.tdwh_crm_yasam_comm_raw_hub y 


SELECT * FROM composecrml1.tdwh_crm_yasam_comm_raw_hub 