SELECT REPLACE(REPLACE(DELTA_VALUE, '-P', ''), '-I', '') AS IDENTITY_TAX_NUMBER,
       "CALC_MOBILEPHONE_1" AS MOBILEPHONE,
      "CALC_TELEPHONE3_1" AS TELEPHONE3,
      "CALC_EMAILADDRESS1_1" AS EMAILADDRESS1,
      CASE
            WHEN TRIM(KOMMART) = 'I' THEN
             KENNUNG
            ELSE
             ''
          END AS WEBSITE,
      "CALC_CDVGSMINFO_1" AS CDVGSMINFO,
      "CALC_CDVEMAILINFO_1" AS CDVEMAILINFO,
      KENNUNG,
           KENNUNG_DT,
           ODS_COMMIT_DATE AS UPDATE_DATE,
           KO# KO#_KEY,
           DELTA_VALUE DELTA_VALUE_KEY,
           SRC_SYS_NM SRC_SYS_NM_KEY
   FROM (SELECT 
              T.CALC_CDVEMAILINFO_1,
       		  T.CALC_CDVGSMINFO_1,
        	  T.CALC_EMAILADDRESS1_1,
         	  T.CALC_TELEPHONE3_1,
       		  T.CALC_MOBILEPHONE_1,
              T.KO#,
              T.KOMMART,
              T.KENNUNG,
              T.KENNUNG_DT,
              T.KOMMQUELLE,
              T.KOMMPRIOR,
              T.PERS#,
              T.KZPRIDIE,
              T.KOMMANM,
              T.KZKOMMDATVALID,
              T.KZWERBE_ERL,
              D.SRC_SYS_NM,
              D.DELTA_VALUE,
              T.ODS_COMMIT_DATE
         FROM "COMPOSECRML1"."TDWH_CRM_TKOMM_HUB" T
         JOIN "COMPOSECRML1"."TDWH_CRM_ABS_DELTA_COMMADDR_HUB" D
           ON T.PERS# = D.MAX_PERS#
        WHERE T.KENNUNG IS NOT NULL)