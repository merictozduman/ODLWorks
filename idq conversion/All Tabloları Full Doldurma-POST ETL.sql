-------------------------------------------------------------------AZS START----------------------------------------------------------

BEGIN
  -------------------------------------------------------------------AZS START----------------------------------------------------------

  DECLARE
      v_chunk_size CONSTANT NUMBER := 10000;
      v_phone_number VARCHAR2(50);
      v_counter NUMBER := 0;
      v_cnt_total NUMBER; 

  BEGIN

      --1.(TEL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur. 
      EXECUTE IMMEDIATE 'TRUNCATE TABLE COMPOSECRML1.stg_phn_azs_stack';

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','1.(TEL) truncate table executed',SYSDATE);

      --2.(TEL) Cache tablosunun eksik kayıtlarını alıyoruz.
      insert /*+append*/ into COMPOSECRML1.stg_phn_azs_stack
      select /*+parallel(32)*/  mobilephone as phone from composecrml1.tdwh_crm_azs_comm_raw_hub  azs1
      where not exists (select 1 from composecrml1.MDM_CRM_PHN_STACK mrm where azs1.mobilephone=mrm.phone) and azs1.mobilephone is not null and trim(azs1.mobilephone)<>''
      union
      select /*+parallel(32)*/  telephone3 as phone from composecrml1.tdwh_crm_azs_comm_raw_hub  azs2
      where not exists (select 1 from composecrml1.MDM_CRM_PHN_STACK mrm where azs2.telephone3=mrm.phone) and azs2.telephone3 is not null and trim(azs2.telephone3)<>''
      union
      select /*+parallel(32)*/ CDVGSMINFO as phone  from composecrml1.tdwh_crm_azs_comm_raw_hub azs3
      where not exists (select 1 from composecrml1.MDM_CRM_PHN_STACK mrm where azs3.CDVGSMINFO=mrm.phone) and azs3.CDVGSMINFO is not null and trim(azs3.CDVGSMINFO)<>'';

      COMMIT;

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','2.(TEL) insert table executed',SYSDATE);
      
      --3.(TEL) Cache Tablosunun eksiklerini tamamlıyoruz. 
        SELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.stg_phn_azs_stack;
        FOR rec IN (SELECT PHONE AS phone_number FROM COMPOSECRML1.stg_phn_azs_stack) LOOP
          v_counter := v_counter + 1;
          if rec.phone_number is not null or rec.phone_number!='' THEN
              DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
              BEGIN
                COMPOSECRML1.PRC_PHN_MAIN_PROCESS(
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

        composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','3.(TEL) cache table inserted',SYSDATE);

      --1.(EMAIL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur.
      EXECUTE IMMEDIATE 'TRUNCATE TABLE COMPOSECRML1.stg_email_azs_stack';

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','1.(EMAIL) truncate table executed',SYSDATE);

      --2.(EMAIL) Cache tablosunun eksik kayıtlarını alıyoruz.
      INSERT /*+APPEND*/ INTO COMPOSECRML1.stg_email_azs_stack
      SELECT /*+parallel(32)*/  emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_azs_comm_raw_hub azs1
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azs1.emailaddress1=mrm.EMAILADDRESS) AND azs1.Emailaddress1 is not null and trim(azs1.Emailaddress1)<>''
      union
      SELECT /*+parallel(32)*/ Cdvemailinfo AS EMAILADDRESS  FROM composecrml1.tdwh_crm_azs_comm_raw_hub  azs2
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azs2.Cdvemailinfo=mrm.EMAILADDRESS) AND azs2.Cdvemailinfo is not null and trim(azs2.Cdvemailinfo)<>'';

      COMMIT;

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','2.(EMAIL) insert table executed',SYSDATE);
      
      --3.(EMAIL) Cache Tablosunun eksiklerini tamamlıyoruz. 
      DECLARE
        v_chunk_size2 CONSTANT NUMBER := 10000;
        v_counter2 NUMBER := 0;
        v_cnt_total2 NUMBER; 

      BEGIN
            sELECT COUNT(*) INTO v_cnt_total2 FROM COMPOSECRML1.stg_email_azs_stack ;
                FOR rec IN (SELECT EMAILADDRESS AS EMAILADDRESS  FROM COMPOSECRML1.stg_email_azs_stack ) LOOP
                  v_counter2 := v_counter2 + 1;

                        DECLARE
                          dec_email_quality_detail_code varchar2(300);
                          dec_cl_email varchar2(300);
                        BEGIN
                          if rec.EMAILADDRESS is not null or rec.EMAILADDRESS!='' THEN
                              COMPOSECRML1.PRC_EMAIL_MAIN_PROCEDURE(rec.EMAILADDRESS,dec_email_quality_detail_code,dec_cl_email);
                          end if; 
                        END;

                        -- Check if the chunk size is reached or it's the last iteration
                        IF MOD(v_counter2, v_chunk_size2) = 0 OR v_counter2 = v_cnt_total2 THEN
                          COMMIT;
                           -- dbms_output.put_line('v_counter: '||v_counter);
                        END IF;
                      END LOOP;
      END;

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','3.(EMAIL) cache table inserted',SYSDATE);

      --4. lOAD edilecek tablonun kopyasını oluşturuyoruz
      EXECUTE IMMEDIATE 'TRUNCATE table COMPOSECRML1.stg_crm_azs_comm_raw_hub'; 
              
      insert /*+append*/ into COMPOSECRML1.stg_crm_azs_comm_raw_hub 
      select /*+parallel(16)*/ * from composecrml1.tdwh_crm_azs_comm_raw_hub;commit;  

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','4. Main table copied',SYSDATE);
      COMMIT;

      --5. load edilecek tabloyu boşaltıyoruz
      EXECUTE IMMEDIATE 'truncate table composecrml1.tdwh_crm_azs_comm_raw_hub';

      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','5. Main table truncated',SYSDATE);

      --6. load edilecek tabloyu full dolduruyoruz.
      insert /*+append*/ into composecrml1.tdwh_crm_azs_comm_raw_hub
      select /*+parallel(azs 16) parallel(mrm1 8) parallel(mrm2 8) parallel(phn1 8) parallel(phn2 8) parallel(phn3 8)*/ 
      azs.id,
      azs.delta_value,
      azs.comm_dev_type,
      azs.explanation,
      azs.identity_no_verified,
      azs.identity_type_verified,
      azs.contact_type_verified,
      azs.identity_no_valid,
      azs.identity_type_valid,
      azs.contact_type_valid,
      azs.cdvgsminfo,
      azs.cdvemailinfo,
      azs.cmmnctn_id_txt,
      azs.mobilephone,
      azs.telephone3,
      azs.emailaddress1,
      azs.ignore_flag,
      azs.website,
      azs.comm_dev_type_dt,
      azs.explanation_dt,
      azs.cdvgsminfo_dt,
      azs.cdvemailinfo_dt,
      azs.cmmnctn_id_txt_dt,
      azs.mobilephone_dt,
      azs.telephone3_dt,
      azs.emailaddress1_dt,
      azs.website_dt,
      azs.runno_insert,
      azs.runno_update,
      mrm1.email_processed emailaddress1_processed,
      mrm1.email_quality_code emailaddress1_quality_code,
      mrm2.email_processed cdvemailinfo_processed,
      mrm2.email_quality_code cdvemailinfo_quality_code,
      phn1.dahili telephone3_dahili,
      phn1.telno1 telephone3_telno1,
      phn1.telno2 telephone3_telno2,
      phn1.telno3 telephone3_telno3,
      case when (NVL(phn1.DAHILI,0) + NVL(phn1.TELNO1,0)+ NVL(phn1.TELNO2,0)+ NVL(phn1.TELNO3,0))=0 then 0 else 1 end telephone3_val,
      case when mrm2.email_quality_code ='genkal00' then 1 else 0 end cdvemailinfo_val,
      case when mrm1.email_quality_code='genkal00' then 1 else 0 end emailaddress1_val,
      phn2.dahili mobilephone_dahili,
      phn2.telno1 mobilephone_telno1,
      phn2.telno2 mobilephone_telno2,
      phn2.telno3 mobilephone_telno3,
      case when (NVL(phn2.DAHILI,0) + NVL(phn2.TELNO1,0)+ NVL(phn2.TELNO2,0)+ NVL(phn2.TELNO3,0))=0 then 0 else 1 end mobilephone_val,
      case when (NVL(phn3.DAHILI,0) + NVL(phn3.TELNO1,0)+ NVL(phn3.TELNO2,0)+ NVL(phn3.TELNO3,0))=0 then 0 else 1 end cdvgsminfo_val,
      phn3.dahili cdvgsminfo_dahili,
      phn3.telno1 cdvgsminfo_telno1,
      phn3.telno2 cdvgsminfo_telno2,
      phn3.telno3 cdvgsminfo_telno3,
      azs.ods_commit_date,
      azs.cdvgsminfo_commit_date,
      azs.cdvemailinfo_commit_date,
      azs.identity_tax_number,
      ODS_OPERATION_INDICATOR
      from 
      COMPOSECRML1.stg_crm_azs_comm_raw_hub azs,
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm1,
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm2,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn1,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn2,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn3
      where 1=1
      and azs.emailaddress1=mrm1.emailaddress(+)
      and azs.cdvemailinfo=mrm2.emailaddress(+)
      and azs.telephone3=phn1.phone(+)
      and azs.mobilephone=phn2.phone(+)
      and azs.cdvgsminfo=phn3.phone(+);

      commit;
      
      composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','6. Main table inserted',SYSDATE); 

  /*    
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_phn_azs_stack        PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_email_azs_stack       PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_crm_azs_comm_raw_hub  PURGE';

          COMMIT; 
    
        composecrml1.PRC_INSERT_FLOW_LOG('AZS_FULL_LOAD','7. Stg tables dropped',SYSDATE); 
  */

  END;



  -------------------------------------------------------------------AZS END----------------------------------------------------------

END;



-------------------------------------------------------------------AZS END----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------YASAM START----------------------------------------------------------

BEGIN
 -------------------------------------------------------------------YASAM START----------------------------------------------------------

  DECLARE
      v_chunk_size CONSTANT NUMBER := 10000;
      v_phone_number VARCHAR2(50);
      v_counter NUMBER := 0;
      v_cnt_total NUMBER; 

  BEGIN

      --1.(TEL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur. 
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_phn_yasam_stack';
      
      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','1.(TEL) truncate table executed',SYSDATE);

      --2.(TEL) Cache tablosunun eksik kayıtlarını alıyoruz.
      insert /*+append*/ into COMPOSECRML1.stg_phn_yasam_stack
      select /*+parallel(32)*/  mobilephone as phone from composecrml1.tdwh_crm_yasam_comm_raw_hub yasam1   
      where not exists (select 1 from COMPOSECRML1.MDM_CRM_PHN_STACK mrm where yasam1.mobilephone=mrm.phone) and yasam1.mobilephone is not null and trim(yasam1.mobilephone)<>''
      union
      select /*+parallel(32)*/  telephone3 as phone from composecrml1.tdwh_crm_yasam_comm_raw_hub yasam2 
      where not exists (select 1 from COMPOSECRML1.MDM_CRM_PHN_STACK mrm where yasam2.telephone3=mrm.phone) and yasam2.telephone3 is not null and trim(yasam2.telephone3)<>'';

      COMMIT;
      
      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','2.(TEL) insert table executed',SYSDATE);

      --3.(TEL) Cache Tablosunun eksiklerini tamamlıyoruz. 
        SELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.stg_phn_yasam_stack;
        FOR rec IN (SELECT PHONE AS phone_number FROM COMPOSECRML1.stg_phn_yasam_stack) LOOP
          v_counter := v_counter + 1;
          if rec.phone_number is not null or rec.phone_number!='' THEN
              DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
              BEGIN
                COMPOSECRML1.PRC_PHN_MAIN_PROCESS(
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

        composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','3.(TEL) cache table inserted',SYSDATE);

      --1.(EMAIL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur.
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_email_yasam_stack';

          composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','1.(EMAIL) table truncated',SYSDATE);
      
      
      --2.(EMAIL) Cache tablosunun eksik kayıtlarını alıyoruz.
      INSERT /*+APPEND*/ INTO COMPOSECRML1.stg_email_yasam_stack
      SELECT /*+parallel(32)*/  emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_azs_comm_raw_hub yasam1
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where yasam1.emailaddress1=mrm.EMAILADDRESS) AND yasam1.Emailaddress1 is not null and trim(yasam1.Emailaddress1)<>'';

      COMMIT;
      
      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','2.(EMAIL) table inserted',SYSDATE);

      --3.(EMAIL) Cache Tablosunun eksiklerini tamamlıyoruz. 
      DECLARE
        v_chunk_size2 CONSTANT NUMBER := 10000;
        v_counter2 NUMBER := 0;
        v_cnt_total2 NUMBER; 

      BEGIN
        sELECT COUNT(*) INTO v_cnt_total2 FROM COMPOSECRML1.stg_email_azs_stack ;
            FOR rec IN (SELECT EMAILADDRESS AS EMAILADDRESS  FROM COMPOSECRML1.stg_email_azs_stack ) LOOP
              v_counter2 := v_counter2 + 1;

                    DECLARE
                      dec_email_quality_detail_code varchar2(300);
                      dec_cl_email varchar2(300);
                    BEGIN
                      if rec.EMAILADDRESS is not null or rec.EMAILADDRESS!='' THEN
                          COMPOSECRML1.PRC_EMAIL_MAIN_PROCEDURE(rec.EMAILADDRESS,dec_email_quality_detail_code,dec_cl_email);
                      end if; 
                    END;

                    -- Check if the chunk size is reached or it's the last iteration
                    IF MOD(v_counter2, v_chunk_size2) = 0 OR v_counter2 = v_cnt_total2 THEN
                      COMMIT;
                       -- dbms_output.put_line('v_counter: '||v_counter);
                    END IF;
            END LOOP;
      END;

      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','3.(EMAIL) cache table inserted',SYSDATE);

      --4. lOAD edilecek tablonun kopyasını oluşturuyoruz
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_crm_yasam_comm_raw_hub'; 
      
      insert /*+append*/ into COMPOSECRML1.stg_crm_yasam_comm_raw_hub
      select /*+parallel(16)*/ * from composecrml1.tdwh_crm_yasam_comm_raw_hub;commit;
      
      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','4. Main table copied',SYSDATE);

      --5. load edilecek tabloyu boşaltıyoruz
      EXECUTE IMMEDIATE 'truncate table composecrml1.tdwh_crm_yasam_comm_raw_hub';

      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','5. Main table truncated',SYSDATE);
      
      --6. load edilecek tabloyu full dolduruyoruz.
      insert /*+append*/into composecrml1.tdwh_crm_yasam_comm_raw_hub 
      select /*+parallel(yasam 16) parallel(mrm1 8)  parallel(phn1 8) parallel(phn2 8) */ 
      yasam.id,
      yasam.delta_value_key,
      yasam.src_sys_nm_key,
      yasam.id_key,
      yasam.comm_id_txt,
      yasam.comm_typ_cd,
      yasam.identity_tax_number,
      yasam.mobilephone,
      yasam.telephone3,
      yasam.emailaddress1,
      yasam.website,
      yasam.runno_insert,
      yasam.runno_update,
      yasam.comm_id_txt_dt,
      yasam.comm_typ_cd_dt,
      yasam.comm_id_txt_adj,
      yasam.comm_typ_cd_adj,
      yasam.mobilephone_adj,
      yasam.telephone3_adj,
      yasam.emailaddress1_adj,
      yasam.website_adj,
      yasam.comm_id_txt_val,
      yasam.comm_typ_cd_val,
      case when (NVL(phn1.DAHILI,0) + NVL(phn1.TELNO1,0)+ NVL(phn1.TELNO2,0)+ NVL(phn1.TELNO3,0))=0 then 0 else 1 end  mobilephone_val,
      case when (NVL(phn2.DAHILI,0) + NVL(phn2.TELNO1,0)+ NVL(phn2.TELNO2,0)+ NVL(phn2.TELNO3,0))=0 then 0 else 1 end telephone3_val,
      case when mrm1.email_quality_code='genkal00' then 1 else 0 end emailaddress1_val,
      yasam.website_val,
      phn1.dahili mobilephone_dahili,
      phn1.telno1 mobilephone_telno1,
      phn1.telno2 mobilephone_telno2,
      phn1.telno3 mobilephone_telno3,
      phn2.dahili telephone3_dahili,
      phn2.telno1 telephone3_telno1,
      phn2.telno2 telephone3_telno2,
      phn2.telno3 telephone3_telno3,
      mrm1.email_processed emailaddress1_processed,
      mrm1.email_quality_code emailaddress1_quality_code,
      ODS_OPERATION_INDICATOR 
      from
      COMPOSECRML1.stg_crm_yasam_comm_raw_hub yasam, 
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm1,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn1,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn2
      where 1=1
      and yasam.emailaddress1=mrm1.emailaddress(+)
      and yasam.mobilephone=phn1.phone(+)
      and yasam.telephone3=phn2.phone(+);

      commit;
      
      composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','6. Main table inserted',SYSDATE); 

  /*    
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_phn_yasam_stack         PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_email_yasam_stack       PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_crm_yasam_comm_raw_hub  PURGE';

          COMMIT; 
          
          composecrml1.PRC_INSERT_FLOW_LOG('YASAM_FULL_LOAD','7. Stg tables dropped',SYSDATE);        
  */

  END;



  -------------------------------------------------------------------YASAM END----------------------------------------------------------
  
END;



-------------------------------------------------------------------YASAM END----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------ABS START----------------------------------------------------------

BEGIN
 -------------------------------------------------------------------ABS START----------------------------------------------------------

  DECLARE
      v_chunk_size CONSTANT NUMBER := 10000;
      v_phone_number VARCHAR2(50);
      v_counter NUMBER := 0;
      v_cnt_total NUMBER; 

  BEGIN

      --1.(TEL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur. 
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_phn_abs_stack';

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','1.(TEL) truncate table executed',SYSDATE);

      --2.(TEL) Cache tablosunun eksik kayıtlarını alıyoruz.
      insert /*+append*/ into COMPOSECRML1.stg_phn_abs_stack
      select /*+parallel(32)*/  mobilephone as phone from composecrml1.tdwh_crm_abs_comm_raw_hub  abs1
      where not exists (select 1 from COMPOSECRML1.MDM_CRM_PHN_STACK mrm where abs1.mobilephone=mrm.phone) and abs1.mobilephone is not null and trim(abs1.mobilephone)<>''
      union
      select /*+parallel(32)*/  telephone3 as phone from composecrml1.tdwh_crm_abs_comm_raw_hub  abs2
      where not exists (select 1 from COMPOSECRML1.MDM_CRM_PHN_STACK mrm where abs2.telephone3=mrm.phone) and abs2.telephone3 is not null and trim(abs2.telephone3)<>''
      union
      select /*+parallel(32)*/ CDVGSMINFO as phone  from composecrml1.tdwh_crm_abs_comm_raw_hub abs3
      where not exists (select 1 from COMPOSECRML1.MDM_CRM_PHN_STACK mrm where abs3.CDVGSMINFO=mrm.phone) and abs3.CDVGSMINFO is not null and trim(abs3.CDVGSMINFO)<>'';

      COMMIT;
      
      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','2.(TEL) insert table executed',SYSDATE);

      --3.(TEL) Cache Tablosunun eksiklerini tamamlıyoruz. 
        SELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.stg_phn_abs_stack;
        FOR rec IN (SELECT PHONE AS phone_number FROM COMPOSECRML1.stg_phn_abs_stack) LOOP
          v_counter := v_counter + 1;
          if rec.phone_number is not null or rec.phone_number!='' THEN
              DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
              BEGIN
                COMPOSECRML1.PRC_PHN_MAIN_PROCESS(
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

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','3.(TEL) cache table inserted',SYSDATE);

      --1.(EMAIL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur.
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_email_abs_stack';

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','1.(EMAIL) table truncated',SYSDATE);

      --2.(EMAIL) Cache tablosunun eksik kayıtlarını alıyoruz.
      INSERT /*+APPEND*/ INTO COMPOSECRML1.stg_email_abs_stack
      SELECT /*+parallel(32)*/  emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_abs_comm_raw_hub abs1
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where abs1.emailaddress1=mrm.EMAILADDRESS) AND abs1.Emailaddress1 is not null and trim(abs1.Emailaddress1)<>''
      union
      SELECT /*+parallel(32)*/ Cdvemailinfo AS EMAILADDRESS  FROM composecrml1.tdwh_crm_abs_comm_raw_hub  abs2
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where abs2.Cdvemailinfo=mrm.EMAILADDRESS) AND abs2.Cdvemailinfo is not null and trim(abs2.Cdvemailinfo)<>'';

      COMMIT;

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','2.(EMAIL) table inserted',SYSDATE);

      --3.(EMAIL) Cache Tablosunun eksiklerini tamamlıyoruz. 
      DECLARE
        v_chunk_size2 CONSTANT NUMBER := 10000;
        v_counter2 NUMBER := 0;
        v_cnt_total2 NUMBER; 

      BEGIN
        sELECT COUNT(*) INTO v_cnt_total2 FROM COMPOSECRML1.stg_email_abs_stack ;
            FOR rec IN (SELECT EMAILADDRESS AS EMAILADDRESS  FROM COMPOSECRML1.stg_email_abs_stack ) LOOP
              v_counter2 := v_counter2 + 1;

                    DECLARE
                      dec_email_quality_detail_code varchar2(300);
                      dec_cl_email varchar2(300);
                    BEGIN
                      if rec.EMAILADDRESS is not null or rec.EMAILADDRESS!='' THEN
                          COMPOSECRML1.PRC_EMAIL_MAIN_PROCEDURE(rec.EMAILADDRESS,dec_email_quality_detail_code,dec_cl_email);
                      end if; 
                    END;

                    -- Check if the chunk size is reached or it's the last iteration
                    IF MOD(v_counter2, v_chunk_size2) = 0 OR v_counter2 = v_cnt_total2 THEN
                      COMMIT;
                       -- dbms_output.put_line('v_counter: '||v_counter);
                    END IF;
            END LOOP;
      END;

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','3.(EMAIL) cache table inserted',SYSDATE);

      --4. lOAD edilecek tablonun kopyasını oluşturuyoruz
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_crm_abs_comm_raw_hub'; 
      
        insert /*+append*/ into COMPOSECRML1.stg_crm_abs_comm_raw_hub 
      select /*+parallel(16)*/ * from composecrml1.tdwh_crm_abs_comm_raw_hub;commit;

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','4. Main table copied',SYSDATE);

      --5. load edilecek tabloyu boşaltıyoruz
      EXECUTE IMMEDIATE 'truncate table composecrml1.tdwh_crm_abs_comm_raw_hub ';

      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','5. Main table truncated',SYSDATE);

      --6. load edilecek tabloyu full dolduruyoruz.
      insert /*+append*/ into composecrml1.tdwh_crm_abs_comm_raw_hub 
      select /*+parallel(azs 16) parallel(mrm1 8) parallel(mrm2 8) parallel(phn1 8) parallel(phn2 8) parallel(phn3 8)*/ 
      abs1.id,
      abs1.ko#_key,
      abs1.delta_value_key,
      abs1.src_sys_nm_key,
      abs1.identity_tax_number,
      abs1.telephone3,
      abs1.emailaddress1,
      abs1.website,
      abs1.cdvgsminfo,
      abs1.cdvemailinfo,
      abs1.mobilephone,
      abs1.mobilephone_dt,
      abs1.telephone3_dt,
      abs1.emailaddress1_dt,
      abs1.website_dt,
      abs1.cdvgsminfo_dt,
      abs1.cdvemailinfo_dt,
      abs1.update_date,
      abs1.runno_insert,
      abs1.runno_update,
      abs1.kennung,
      abs1.mobilephone_adj,
      abs1.telephone3_adj,
      abs1.emailaddress1_adj,
      abs1.cdvgsminfo_adj,
      abs1.cdvemailinfo_adj,
      case when (NVL(phn2.DAHILI,0) + NVL(phn2.TELNO1,0)+ NVL(phn2.TELNO2,0)+ NVL(phn2.TELNO3,0))=0 then 0 else 1 end mobilephone_val,
      case when (NVL(phn1.DAHILI,0) + NVL(phn1.TELNO1,0)+ NVL(phn1.TELNO2,0)+ NVL(phn1.TELNO3,0))=0 then 0 else 1 end telephone3_val,
      case when mrm1.email_quality_code='genkal00' then 1 else 0 end  emailaddress1_val,
      abs1.website_val,
      case when (NVL(phn3.DAHILI,0) + NVL(phn3.TELNO1,0)+ NVL(phn3.TELNO2,0)+ NVL(phn3.TELNO3,0))=0 then 0 else 1 end cdvgsminfo_val,
      case when mrm2.email_quality_code='genkal00' then 1 else 0 end cdvemailinfo_val,
      abs1.website_adj,
      phn2.dahili mobilephone_dahili,
      phn2.telno1 mobilephone_telno1,
      phn2.telno2 mobilephone_telno2,
      phn2.telno3 mobilephone_telno3,
      phn1.dahili telephone3_dahili,
      phn1.telno1 telephone3_telno1,
      phn1.telno2 telephone3_telno2,
      phn1.telno3 telephone3_telno3,
      phn3.dahili cdvgsminfo_dahili,
      phn3.telno1 cdvgsminfo_telno1,
      phn3.telno2 cdvgsminfo_telno2,
      phn3.telno3 cdvgsminfo_telno3,
      mrm1.email_processed emailaddress1_processed,
      mrm1.email_quality_code emailaddress1_quality_code,
      mrm2.email_processed cdvemailinfo_processed,
      mrm2.email_quality_code cdvemailinfo_quality_code,
      abs1.ODS_OPERATION_INDICATOR
      from
      COMPOSECRML1.stg_crm_abs_comm_raw_hub abs1,
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm1,
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm2,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn1,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn2,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn3
      where 1=1
      and abs1.emailaddress1=mrm1.emailaddress(+)
      and abs1.cdvemailinfo=mrm2.emailaddress(+)
      and abs1.telephone3=phn1.phone(+)
      and abs1.mobilephone=phn2.phone(+)
      and abs1.cdvgsminfo=phn3.phone(+);

      commit;

    
      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','6. Main table inserted',SYSDATE); 

  /*      
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_phn_abs_stack        PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_email_abs_stack       PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_crm_abs_comm_raw_hub  PURGE';

          COMMIT; 
    
      composecrml1.PRC_INSERT_FLOW_LOG('ABS_FULL_LOAD','7. Stg tables dropped',SYSDATE); 
  */    
      
  END;



  -------------------------------------------------------------------ABS END------------------------------------------------------------
  
END;


-------------------------------------------------------------------ABS END------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------AZHE START----------------------------------------------------------
BEGIN
 -------------------------------------------------------------------AZHE START----------------------------------------------------------

  DECLARE
      v_chunk_size CONSTANT NUMBER := 10000;
      v_phone_number VARCHAR2(50);
      v_counter NUMBER := 0;
      v_cnt_total NUMBER; 

  BEGIN

      --1.(TEL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur. 
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_phn_azhe_stack';

      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','1.(TEL) table truncated',SYSDATE);

      --2.(TEL) Cache tablosunun eksik kayıtlarını alıyoruz.
      insert /*+append*/ into COMPOSECRML1.stg_phn_azhe_stack 
      select /*+parallel(32)*/  mobilephone as phone from composecrml1.tdwh_crm_azhe_comm_raw_hub  azhe1
      where not exists (select 1 from composecrml1.MDM_CRM_PHN_STACK mrm where azhe1.mobilephone=mrm.phone) and azhe1.mobilephone is not null and trim(azhe1.mobilephone)<>''
      union
      select /*+parallel(32)*/  telephone3 as phone from composecrml1.tdwh_crm_azhe_comm_raw_hub  azhe2
      where not exists (select 1 from composecrml1.MDM_CRM_PHN_STACK mrm where azhe2.telephone3=mrm.phone) and azhe2.telephone3 is not null and trim(azhe2.telephone3)<>''
      union
      select /*+parallel(32)*/ CDVGSMINFO as phone  from composecrml1.tdwh_crm_azhe_comm_raw_hub azhe3
      where not exists (select 1 from composecrml1.MDM_CRM_PHN_STACK mrm where azhe3.CDVGSMINFO=mrm.phone) and azhe3.CDVGSMINFO is not null and trim(azhe3.CDVGSMINFO)<>'';

      COMMIT;
      
      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','2.(TEL) table inserted',SYSDATE);

      --3.(TEL) Cache Tablosunun eksiklerini tamamlıyoruz. 
        SELECT COUNT(*) INTO v_cnt_total FROM COMPOSECRML1.stg_phn_azhe_stack ;
        FOR rec IN (SELECT PHONE AS phone_number FROM COMPOSECRML1.stg_phn_azhe_stack) LOOP
          v_counter := v_counter + 1;
          if rec.phone_number is not null or rec.phone_number!='' THEN
              DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
              BEGIN
                COMPOSECRML1.PRC_PHN_MAIN_PROCESS(
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

      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','3.(TEL) cache table inserted',SYSDATE);
      
      
      --1.(EMAIL) AZS de olup cache tablosunda olmayan kayıtların tutulduğu tablodur.
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_email_azhe_stack';

      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','1.(EMAIL) table truncated',SYSDATE);

      --2.(EMAIL) Cache tablosunun eksik kayıtlarını alıyoruz.
      INSERT /*+APPEND*/ INTO COMPOSECRML1.stg_email_azhe_stack
      SELECT /*+parallel(32)*/  emailaddress1 AS EMAILADDRESS FROM composecrml1.tdwh_crm_azhe_comm_raw_hub azhe1
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azhe1.emailaddress1=mrm.EMAILADDRESS) AND azhe1.Emailaddress1 is not null and trim(azhe1.Emailaddress1)<>''
      union
      SELECT /*+parallel(32)*/ Cdvemailinfo AS EMAILADDRESS  FROM composecrml1.tdwh_crm_azhe_comm_raw_hub  azhe2
      where NOT EXISTS (SELECT 1 FROM COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm where azhe2.Cdvemailinfo=mrm.EMAILADDRESS) AND azhe2.Cdvemailinfo is not null and trim(azhe2.Cdvemailinfo)<>'';

      COMMIT;
      
      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','2.(EMAIL) table inserted',SYSDATE);

      --3.(EMAIL) Cache Tablosunun eksiklerini tamamlıyoruz. 
      DECLARE
        v_chunk_size2 CONSTANT NUMBER := 10000;
        v_counter2 NUMBER := 0;
        v_cnt_total2 NUMBER; 

      BEGIN
        sELECT COUNT(*) INTO v_cnt_total2 FROM COMPOSECRML1.stg_email_azhe_stack ;
            FOR rec IN (SELECT EMAILADDRESS AS EMAILADDRESS  FROM COMPOSECRML1.stg_email_azhe_stack ) LOOP
              v_counter2 := v_counter2 + 1;

                    DECLARE
                      dec_email_quality_detail_code varchar2(300);
                      dec_cl_email varchar2(300);
                    BEGIN
                      if rec.EMAILADDRESS is not null or rec.EMAILADDRESS!='' THEN
                          COMPOSECRML1.PRC_EMAIL_MAIN_PROCEDURE(rec.EMAILADDRESS,dec_email_quality_detail_code,dec_cl_email);
                      end if; 
                    END;

                    -- Check if the chunk size is reached or it's the last iteration
                    IF MOD(v_counter2, v_chunk_size2) = 0 OR v_counter2 = v_cnt_total2 THEN
                      COMMIT;
                       -- dbms_output.put_line('v_counter: '||v_counter);
                    END IF;
            END LOOP;
      END;

      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','3.(EMAIL) cache table inserted',SYSDATE);

      --4. lOAD edilecek tablonun kopyasını oluşturuyoruz
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.stg_crm_azhe_comm_raw_hub'; 

      insert /*+append*/ into COMPOSECRML1.stg_crm_azhe_comm_raw_hub
      select /*+parallel(16)*/ * from COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB ; commit;
    
      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','4. Main table copied',SYSDATE);

      --5. load edilecek tabloyu boşaltıyoruz
      EXECUTE IMMEDIATE 'truncate table COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB';
      
      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','5. Main table truncated',SYSDATE); 

      --6. load edilecek tabloyu full dolduruyoruz.
      insert /*+append*/into COMPOSECRML1.TDWH_CRM_AZHE_COMM_RAW_HUB
      select /*+parallel(azs 16) parallel(mrm1 8) parallel(mrm2 8) parallel(phn1 8) parallel(phn2 8) parallel(phn3 8)*/ 
      azhe.id,
      azhe.delta_value_key,
      azhe.telephone_key,
      azhe.unit_no_key,
      azhe.validity_end_key,
      azhe.max_process_date_key,
      azhe.mobilephone,
      azhe.telephone3,
      azhe.emailaddress1,
      azhe.cdvgsminfo,
      azhe.cdvemailinfo,
      azhe.identity_tax_number,
      azhe.website,
      azhe.mobilephone_dt,
      azhe.telephone3_dt,
      azhe.emailaddress1_dt,
      azhe.website_dt,
      azhe.cdvgsminfo_dt,
      azhe.cdvemailinfo_dt,
      azhe.runno_insert,
      azhe.runno_update,
      phn1.dahili telephone3_dahili,
      phn2.dahili mobilephone_dahili,
      phn3.dahili cdvgsminfo_dahili,
      phn1.telno1 telephone3_telno1,
      phn1.telno2 telephone3_telno2,
      phn1.telno3 telephone3_telno3,
      phn2.telno1 mobilephone_telno1,
      phn2.telno2 mobilephone_telno2,
      phn2.telno3 mobilephone_telno3,
      phn3.telno1 cdvgsminfo_telno1,
      phn3.telno2 cdvgsminfo_telno2,
      phn3.telno3 cdvgsminfo_telno3,
      azhe.mobilephone_adj,
      azhe.telephone3_adj,
      azhe.emailaddress1_adj,
      azhe.website_adj,
      azhe.cdvgsminfo_adj,
      azhe.cdvemailinfo_adj,
      case when (NVL(phn2.DAHILI,0) + NVL(phn2.TELNO1,0)+ NVL(phn2.TELNO2,0)+ NVL(phn2.TELNO3,0))=0 then 0 else 1 end mobilephone_val,
      case when (NVL(phn1.DAHILI,0) + NVL(phn1.TELNO1,0)+ NVL(phn1.TELNO2,0)+ NVL(phn1.TELNO3,0))=0 then 0 else 1 end telephone3_val,
      case when mrm1.email_quality_code='genkal00' then 1 else 0 end emailaddress1_val,
      azhe.website_val,
      case when (NVL(phn3.DAHILI,0) + NVL(phn3.TELNO1,0)+ NVL(phn3.TELNO2,0)+ NVL(phn3.TELNO3,0))=0 then 0 else 1 end cdvgsminfo_val,
      case when mrm2.email_quality_code='genkal00' then 1 else 0 end cdvemailinfo_val,
      mrm1.email_quality_code emailaddress1_quality_code,
      mrm2.email_quality_code cdvemailinfo_quality_code,
      mrm1.email_processed emailaddress1_processed,
      mrm2.email_processed cdvemailinfo_processed,
      azhe.ods_commit_date,
      ODS_OPERATION_INDICATOR
      from 
      COMPOSECRML1.stg_crm_azhe_comm_raw_hub azhe,
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm1,
      COMPOSECRML1.MDM_CRM_EMAIL_STACK mrm2,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn1,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn2,
      COMPOSECRML1.MDM_CRM_PHN_STACK phn3
      where 1=1
      and azhe.emailaddress1=mrm1.emailaddress(+)
      and azhe.cdvemailinfo=mrm2.emailaddress(+)
      and azhe.telephone3=phn1.phone(+)
      and azhe.mobilephone=phn2.phone(+)
      and azhe.cdvgsminfo=phn3.phone(+) ;
      
      commit;

      
      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','6. Main table inserted',SYSDATE);

  /*    
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_phn_azhe_stack        PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_email_azhe_stack       PURGE';
      EXECUTE IMMEDIATE 'DROP TABLE COMPOSECRML1.stg_crm_azhe_comm_raw_hub PURGE';

          COMMIT; 
      
      composecrml1.PRC_INSERT_FLOW_LOG('AZHE_FULL_LOAD','7. Stg tables dropped',SYSDATE); 
  */
    
  END;


  -------------------------------------------------------------------AZHE END------------------------------------------------------------
END;

-------------------------------------------------------------------AZHE END------------------------------------------------------------


