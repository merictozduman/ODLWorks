SELECT DELTA_VALUE,
     COMM_DEV_TYPE,
       EXPLANATION,
       COMM_DEV_TYPE_DT,
       EXPLANATION_DT,
       CDVGSMINFO,
       CDVEMAILINFO,
       CMMNCTN_ID_TXT,
       CASE
            WHEN COMM_DEV_TYPE IN ('0040') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION
               ELSE
                CMMNCTN_ID_TXT
             END
            ELSE
             NULL
          END AS MOBILEPHONE,
      CASE
            WHEN COMM_DEV_TYPE IN ('0020') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION
               ELSE
                CMMNCTN_ID_TXT
             END
            ELSE
             NULL
          END AS TELEPHONE3,
      CASE
            WHEN COMM_DEV_TYPE IN ('0090', '0100', '0121') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION
               ELSE
                CMMNCTN_ID_TXT
             END
            ELSE
             NULL
          END AS EMAILADDRESS1,
    CASE
            WHEN COMM_DEV_TYPE IN ('0200') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION
               ELSE
                CMMNCTN_ID_TXT
             END
            ELSE
             NULL
          END AS WEBSITE,
       CDVGSMINFO_DT,
       CDVEMAILINFO_DT,
       CMMNCTN_ID_TXT_DT,
       CASE
            WHEN COMM_DEV_TYPE IN ('0040') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION_DT
               ELSE
                CMMNCTN_ID_TXT_DT
             END
            ELSE
             NULL
          END AS MOBILEPHONE_DT,
      CASE
            WHEN COMM_DEV_TYPE IN ('0020') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION_DT
               ELSE
                CMMNCTN_ID_TXT_DT
             END
            ELSE
             NULL
          END AS TELEPHONE3_DT,
      CASE
            WHEN COMM_DEV_TYPE IN ('0090', '0100', '0121') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION_DT
               ELSE
                CMMNCTN_ID_TXT_DT
             END
            ELSE
             NULL
          END AS EMAILADDRESS1_DT,
    CASE
            WHEN COMM_DEV_TYPE IN ('0200') THEN
             CASE
               WHEN CMMNCTN_ID_TXT = '' THEN
                EXPLANATION_DT
               ELSE
                CMMNCTN_ID_TXT_DT
             END
            ELSE
             NULL
          END AS WEBSITE_DT,
       ignore_flag,
       cast(contact_type_valid as varchar2(20)) contact_type_valid,
       cast(contact_type_verified as varchar2(20)) contact_type_verified,
       cast(identity_no_valid as varchar2(30)) identity_no_valid,
       cast(identity_no_verified as varchar2(30)) identity_no_verified,
       cast(identity_type_valid as varchar2(10)) identity_type_valid,
       cast(identity_type_verified as varchar2(10)) identity_type_verified
  FROM (SELECT MAIN.COMM_DEV_TYPE,
               MAIN.EXPLANATION,
             MAIN.COMM_DEV_TYPE_DT,
               MAIN.EXPLANATION_DT,
               MAIN.DELTA_VALUE,
            CASE
                WHEN MAIN.COMM_DEV_TYPE IN ('0110',
                                            '0081',
                                            '0080',
                                            '0070',
                                            '0050',
                                            '0040',
                                            '0030',
                                            '0020',
                                            '0010',
                                            '0060',
                                            '0120') THEN
                 EXPLANATION -- kalite kurallarından geçirilmiş olmalı
                ELSE
                 CASE
                   WHEN MAIN.COMM_DEV_TYPE IN ('0090',
                                              '0100',
                                              '0121',
                                              '0200',
                                              '2090',
                                              '2040',
                                              '3091',
                                              '3092',
                                              '0') THEN
                    EXPLANATION -- kalite kurallarından geçirilmiş olmalı
                   ELSE
                    ''
                 END
              END AS CMMNCTN_ID_TXT,
            CASE
                WHEN MAIN.COMM_DEV_TYPE IN ('0110',
                                            '0081',
                                            '0080',
                                            '0070',
                                            '0050',
                                            '0040',
                                            '0030',
                                            '0020',
                                            '0010',
                                            '0060',
                                            '0120') THEN
                 EXPLANATION_DT
                ELSE
                 CASE
                   WHEN MAIN.COMM_DEV_TYPE IN ('0090',
                                              '0100',
                                              '0121',
                                              '0200',
                                              '2090',
                                              '2040',
                                              '3091',
                                              '3092',
                                              '0') THEN
                    EXPLANATION_DT
                   ELSE
                    null
                 END
              END AS CMMNCTN_ID_TXT_DT,
             MAIN.ignore_flag,
               CASE
                 WHEN NVL(VR.CONTACT_TYPE, VL.CONTACT_TYPE) = 'GSM' THEN
                  NVL(VR.CONTACT_DATA_VERIFIED, VL.CONTACT_DATA_VALID)
                 ELSE
                  NULL
               END AS CDVGSMINFO,
               CASE
                 WHEN NVL(VR.CONTACT_TYPE, VL.CONTACT_TYPE) = 'EMAIL' THEN
                  NVL(VR.CONTACT_DATA_VERIFIED, VL.CONTACT_DATA_VALID)
                 ELSE
                  NULL
               END AS CDVEMAILINFO,
            CASE
                 WHEN NVL(VR.CONTACT_TYPE, VL.CONTACT_TYPE) = 'GSM' THEN
                  NVL(VR.CONTACT_DATA_VERIFIED_DT, VL.CONTACT_DATA_VALID_DT)
                 ELSE
                  NULL
               END AS CDVGSMINFO_DT,
               CASE
                 WHEN NVL(VR.CONTACT_TYPE, VL.CONTACT_TYPE) = 'EMAIL' THEN
                  NVL(VR.CONTACT_DATA_VERIFIED_DT, VL.CONTACT_DATA_VALID_DT)
                 ELSE
                  NULL
               END AS CDVEMAILINFO_DT,
          coalesce(vl.contact_type, '$QCOMPOSE$') contact_type_valid,
            coalesce(vr.contact_type, '$QCOMPOSE$') contact_type_verified,
         coalesce(vl.identity_no, '$QCOMPOSE$') identity_no_valid,
            coalesce(vr.identity_no, '$QCOMPOSE$') identity_no_verified,
              coalesce(vl.identity_type, '$QCOMPOSE$') identity_type_valid,
            coalesce(vr.contact_type, '$QCOMPOSE$') identity_type_verified
           --  ,main.runno_update historyno
          FROM (select cdh.comm_dev_type,
                        cdh.explanation,
                    cdh.comm_dev_type_dt,
                        cdh.explanation_dt,
                        cdh.delta_value,
                        cdh.validity_start_date,
                        cdh.validity_end_date,
                    cdh.ignore_flag
                    -- ,cdh.runno_update
                  from composecrml1.tdwh_crm_stg_comm_devices_agg_hub cdh
                  where coalesce(cdh.ignore_flag,0) = 0
                   and (cdh.runno_update > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_OPUS_L3')
                         and cdh.runno_update <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_OPUS_L3'))
                 union all
                 select cdh.comm_dev_type,
                        cdh.explanation,
                    cdh.comm_dev_type_dt,
                        cdh.explanation_dt,
                        cdh.delta_value,
                        cdh.validity_start_date,
                        cdh.validity_end_date,
                    cdh.ignore_flag
                    -- ,cdh.runno_update
                  from composecrml1.tdwh_crm_stg_comm_devices_agg_hub cdh
                  where coalesce(cdh.ignore_flag,0) = 0
                   and not (cdh.runno_update > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_OPUS_L3')
                         and cdh.runno_update <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_OPUS_L3'))
                   and cdh.delta_value in (
                                        select  ch1.delta_value
                                        from composecrml1."TDWH_CRM_STG_ALZ_CCDV_VERIFICATION_AGG_HUB" ch1
                                        where ch1.identity_no <> '$QCOMPOSE$'
                                          and greatest(ch1.max_valid_id, ch1.max_verified_id) > 0
                                          and (ch1.runno_update > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_OPUS_L3')
                                          and ch1.runno_update <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_OPUS_L3'))
                                          )
                                          
                 
                 ) MAIN
          LEFT OUTER JOIN (select ch2.delta_value, ch2.CONTACT_DATA_VERIFIED, ch2.contact_type,
                           ch2.identity_no, ch2.identity_type, ch2.CONTACT_DATA_VERIFIED_DT
                          from composecrml1."TDWH_CRM_STG_ALZ_CCDV_VERIFICATION_AGG_HUB" ch2
                          where ch2.identity_no <> '$QCOMPOSE$'
                          and ch2.max_verified_id > 0
                          ) VR
            ON MAIN.DELTA_VALUE = VR.DELTA_VALUE
          LEFT OUTER JOIN (select ch1.delta_value, ch1.CONTACT_DATA_VALID, ch1.contact_type,
                           ch1.identity_no, ch1.identity_type, ch1.CONTACT_DATA_VALID_DT
                          from composecrml1."TDWH_CRM_STG_ALZ_CCDV_VERIFICATION_AGG_HUB" ch1
                          where ch1.identity_no <> '$QCOMPOSE$'
                          and ch1.max_valid_id > 0) VL
            ON MAIN.DELTA_VALUE = VL.DELTA_VALUE)