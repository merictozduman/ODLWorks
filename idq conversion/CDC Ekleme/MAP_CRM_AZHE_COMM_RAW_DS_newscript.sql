SELECT 
       M.UNIT_NO AS UNIT_NO_KEY,
       M.VALIDITY_END AS VALIDITY_END_KEY,
       M.DELTA_VALUE AS DELTA_VALUE_KEY,
     M.TELEPHONE_KEY,
       --TO_DATE(NVL(TO_CHAR(MPD.MAX_PROCESS_DATE, 'DD.MM.YYYY HH24:MI:SS'), '01.01.19 00:00:00')) AS   MAX_PROCESS_DATE_KEY,
     CASE WHEN  MPD.MAX_PROCESS_DATE IS NULL THEN TO_DATE('01.01.1000', 'DD.MM.YYYY HH24:MI:SS') ELSE MPD.MAX_PROCESS_DATE END AS MAX_PROCESS_DATE_KEY,
     CAST( REPLACE(REPLACE(DELTA_VALUE, '-P', ''), '-I', '') AS VARCHAR2(30)) AS IDENTITY_TAX_NUMBER,
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END AS MOBILEPHONE,
		COMPOSECRML1.FNC_PHN_DAHILI('MAP_CRM_AZHE_COMM_RAW_DS',
		 CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END 
		) AS mobilephone_dahili,
		COMPOSECRML1.FNC_PHN_TELNO1('MAP_CRM_AZHE_COMM_RAW_DS',
         CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END 		
		) AS mobilephone_telno1,
		COMPOSECRML1.FNC_PHN_TELNO2('MAP_CRM_AZHE_COMM_RAW_DS',
		  CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END 
		) AS mobilephone_telno2,
		COMPOSECRML1.FNC_PHN_TELNO3('MAP_CRM_AZHE_COMM_RAW_DS',
		  CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END 
		) AS mobilephone_telno3,		   
		COMPOSECRML1.FNC_PHN_ISVALID('MAP_CRM_AZHE_COMM_RAW_DS',
		  CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END 
		) AS mobilephone_val,		   
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'TEL' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END AS TELEPHONE3,
		COMPOSECRML1.FNC_PHN_DAHILI('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'TEL' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS telephone3_dahili,
		COMPOSECRML1.FNC_PHN_TELNO1('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'TEL' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS telephone3_telno1,
		COMPOSECRML1.FNC_PHN_TELNO2('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'TEL' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS telephone3_telno2,
		COMPOSECRML1.FNC_PHN_TELNO3('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'TEL' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS telephone3_telno3,		   
		COMPOSECRML1.FNC_PHN_ISVALID('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'TEL' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS telephone3_val,		   
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END AS EMAILADDRESS1,
		COMPOSECRML1.FNC_EMAIL_PROCESSED('MAP_CRM_AZHE_COMM_RAW_DS',
		  CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END
		) AS emailaddress1_processed,
		COMPOSECRML1.FNC_EMAIL_QUALITY_CODE('MAP_CRM_AZHE_COMM_RAW_DS',
		   CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END
		) AS emailaddress1_quality_code,		   
		COMPOSECRML1.FNC_EMAIL_ISVALID('MAP_CRM_AZHE_COMM_RAW_DS',
		   CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END
		) AS emailaddress1_val,		   
       CASE
             WHEN LTRIM(RTRIM(M.TEL_TYPE)) = 'WEB' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END AS WEBSITE,
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END AS CDVGSMINFO,
		COMPOSECRML1.FNC_PHN_DAHILI('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvgsminfo_dahili,
		COMPOSECRML1.FNC_PHN_TELNO1('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvgsminfo_telno1,
		COMPOSECRML1.FNC_PHN_TELNO2('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvgsminfo_telno2,
		COMPOSECRML1.FNC_PHN_TELNO3('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvgsminfo_telno3,		   
		COMPOSECRML1.FNC_PHN_ISVALID('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'POR' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvgsminfo_val,		  
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END AS CDVEMAILINFO,
		COMPOSECRML1.FNC_EMAIL_PROCESSED('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvemailinfo_processed,
		COMPOSECRML1.FNC_EMAIL_QUALITY_CODE('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvemailinfo_quality_code,		   
	  COMPOSECRML1.FNC_EMAIL_ISVALID('MAP_CRM_AZHE_COMM_RAW_DS',
       CASE
             WHEN MPD.MAX_PROCESS_DATE IS NOT NULL AND
                  LTRIM(RTRIM(M.TEL_TYPE)) = 'EML' THEN
              M.CONTACT_INFO -- kalite kurallarından geçirilmiş olmalı
             ELSE
              NULL
           END		
		) AS cdvemailinfo_val,		   
           CONTACT_INFO_DT  AS MOBILEPHONE_DT,
           CONTACT_INFO_DT  AS TELEPHONE3_DT,
           CONTACT_INFO_DT  AS EMAILADDRESS1_DT,
           CONTACT_INFO_DT  AS WEBSITE_DT,
           CONTACT_INFO_DT  AS CDVGSMINFO_DT,
           CONTACT_INFO_DT  AS CDVEMAILINFO_DT
  FROM (SELECT MAIN.UNIT_NO,
               MAIN.SRC_SYS_NM,
               MAIN.DELTA_VALUE,
               MAIN.VALIDITY_END,
               TEL.ADDRESS_NO,
               TEL.TEL_TYPE,
               TEL.CONTACT_INFO,
               TEL.CONTACT_INFO_DT,
               TEL.PROCESS_DATE,
         TEL.TELEPHONE_KEY,
         TEL.RUNNO_UPDATE AS TEL_RUNNO_UPDATE,
         MAIN_RUNNO_UPDATE
          FROM (SELECT M.UNIT_NO, UMN.SRC_SYS_NM, UMN.DELTA_VALUE , M.VALIDITY_END ,
            GREATEST(UMN.RUNNO_UPDATE , M.RUNNO_UPDATE) MAIN_RUNNO_UPDATE 
                  FROM COMPOSECRML1.TDWH_CRM_UNIT_MASTER_HUB M
                  JOIN (SELECT MN.UNIT_NO AS PART_ID,
                              MN.SRC_SYS_NM_1 SRC_SYS_NM,
                              MN.CALC_DELTA_VALUE_2 AS DELTA_VALUE,
                              MAX(MN.VALIDITY_END) VALIDITY_END,
                MAX(GREATEST(MN.RUNNO_UPDATE, MX.RUNNO_UPDATE)) RUNNO_UPDATE 
                         FROM COMPOSECRML1.TDWH_CRM_UNIT_MASTER_HUB MN
                         JOIN (SELECT MAX(UNIT_NO) AS MAX_PART_ID,
                   MAX(RUNNO_UPDATE) RUNNO_UPDATE,
                                     CALC_DELTA_VALUE_2 MAX_DELTA_VALUE
                                FROM COMPOSECRML1.TDWH_CRM_UNIT_MASTER_HUB
                               GROUP BY CALC_DELTA_VALUE_2
                 ) MX
                           ON MN.UNIT_NO = MX.MAX_PART_ID
                          AND MN.CALC_DELTA_VALUE_2 = MX.MAX_DELTA_VALUE
                        GROUP BY MN.UNIT_NO, MN.SRC_SYS_NM_1, MN.CALC_DELTA_VALUE_2
            ) UMN
                    ON M.UNIT_NO = UMN.PART_ID
                   AND M.VALIDITY_END = UMN.VALIDITY_END
        ) MAIN
          JOIN (SELECT UNIT_NO,
                      ADDRESS_NO,
                      TEL_TYPE,
                      CONTACT_INFO,
                      PROCESS_DATE,
                      CONTACT_INFO_DT,
            TELEPHONE_KEY,
            RUNNO_UPDATE
                 FROM COMPOSECRML1.TDWH_CRM_TELEPHONE_HUB) TEL
            ON MAIN.UNIT_NO = TEL.UNIT_NO) M
  LEFT OUTER JOIN (SELECT UNIT_NO,
                          ADDRESS_NO,
                          TEL_TYPE,
                          MAX_PROCESS_DATE,
              TL.RUNNO_UPDATE AS TL_RUNNO_UPDATE,
              MN.RUNNO_UPDATE AS MN_RUNNO_UPDATE
                     FROM COMPOSECRML1.TDWH_CRM_TELEPHONE_MAX_PROCESS_DATE_HUB TL
                     JOIN (SELECT DISTINCT UNIT_NO AS PART_ID , RUNNO_UPDATE
                            FROM COMPOSECRML1.TDWH_CRM_UNIT_MASTER_HUB) MN
                       ON TL.UNIT_NO = MN.PART_ID) MPD
    ON MPD.UNIT_NO = M.UNIT_NO
   AND MPD.ADDRESS_NO = M.ADDRESS_NO
   AND MPD.TEL_TYPE = M.TEL_TYPE
   AND MPD.MAX_PROCESS_DATE = M.PROCESS_DATE
   WHERE  (
    (M.TEL_RUNNO_UPDATE > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1') 
    AND M.TEL_RUNNO_UPDATE <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1'))
  ) 
  OR (
    (M.MAIN_RUNNO_UPDATE > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1') 
    AND M.MAIN_RUNNO_UPDATE <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1'))
  ) 
  OR (
    (MPD.TL_RUNNO_UPDATE > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1') 
    AND MPD.TL_RUNNO_UPDATE <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1'))
  ) 
  OR (
    (MPD.MN_RUNNO_UPDATE > (select PROCESSED_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1') 
    AND MPD.MN_RUNNO_UPDATE <= (select SRC_MAX_RUNNO FROM COMPOSECRML1.STG_RUN_CONFIG WHERE config_name = 'STG_HAYAT_L1'))
  ) 
  