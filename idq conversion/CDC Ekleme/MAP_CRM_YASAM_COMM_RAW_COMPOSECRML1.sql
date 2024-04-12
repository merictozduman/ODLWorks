SELECT 
      cast((ID_KEY||'-'||COMM_TYP_CD) as varchar2(100)) as ID_KEY,
      DELTA_VALUE_KEY,
      SRC_SYS_NM_KEY,
      CAST(REPLACE(REPLACE(DELTA_VALUE_KEY, '-P', ''), '-I', '') AS VARCHAR2(100)) AS IDENTITY_TAX_NUMBER,
      CASE
            WHEN COMM_TYP_CD = 'CEP' THEN
             COMM_ID_TXT
            ELSE
             ''
          END AS MOBILEPHONE,
      CASE
            WHEN COMM_TYP_CD = 'TEL' THEN
             COMM_ID_TXT
            ELSE
             ''
          END AS TELEPHONE3,
      CASE
            WHEN COMM_TYP_CD = 'EML' THEN
             COMM_ID_TXT
            ELSE
             ''
          END AS EMAILADDRESS1,
      CASE
            WHEN COMM_TYP_CD = 'WEB' THEN
             COMM_ID_TXT
            ELSE
             ''
          END AS WEBSITE,
          COMM_TYP_CD_DT,
          COMM_ID_TXT_DT,
          COMM_ID_TXT,
          COMM_TYP_CD
FROM (SELECT  SRC_SYS_NM_KEY,
              DELTA_VALUE_KEY,
              ID_KEY,
              COMM_ID_TXT,
              COMM_ID_TXT_DT,
              COMM_TYP_CD,
              COMM_TYP_CD_DT
         FROM "COMPOSECRML1"."TDWH_CRM_YASAM_COMM_RAW_SQ1_HUB" Q1 where ID != 0
        
       UNION

       SELECT SRC_SYS_NM_KEY,
              DELTA_VALUE_KEY,
              ID_KEY,
              COMM_ID_TXT,
              COMM_ID_TXT_DT,
              COMM_TYP_CD,
              COMM_TYP_CD_DT
         FROM "COMPOSECRML1"."TDWH_CRM_YASAM_COMM_RAW_SQ2_HUB" Q2 where ID != 0
         

       UNION

       SELECT SRC_SYS_NM_KEY,
              DELTA_VALUE_KEY,
              ID_KEY,
              COMM_ID_TXT,
              COMM_ID_TXT_DT,
              COMM_TYP_CD,
              COMM_TYP_CD_DT
         FROM "COMPOSECRML1"."TDWH_CRM_YASAM_COMM_RAW_SQ3_HUB" Q3 where ID != 0

       UNION

       SELECT SRC_SYS_NM_KEY,
              DELTA_VALUE_KEY,
              ID_KEY,
              COMM_ID_TXT,
              COMM_ID_TXT_DT,
              COMM_TYP_CD,
              COMM_TYP_CD_DT
         FROM "COMPOSECRML1"."TDWH_CRM_YASAM_COMM_RAW_SQ4_HUB" Q4 where ID != 0

       UNION

       SELECT SRC_SYS_NM_KEY,
              DELTA_VALUE_KEY,
              ID_KEY,
              COMM_ID_TXT,
              COMM_ID_TXT_DT,
              COMM_TYP_CD,
              COMM_TYP_CD_DT
         FROM "COMPOSECRML1"."TDWH_CRM_YASAM_COMM_RAW_SQ5_HUB" Q5 where ID != 0
)