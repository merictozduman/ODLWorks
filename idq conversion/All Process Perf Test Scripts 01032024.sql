--146,176,543
select COUNT(*) from composecrml1.mdm_crm_azs_comm_raw_test

--22,746,069
select COUNT(*) from composecrml1.mdm_crm_abs_comm_raw_test


SELECT RUNNO_UPDATE,COUNT(*) FROM composecrml1.mdm_crm_azs_comm_raw_test
GROUP BY RUNNO_UPDATE
ORDER BY 1

RUNNOUPDATE: 10254  CNT: 284423 6dk

SELECT * FROM composecrml1.mdm_crm_azs_comm_raw_test
where RUNNO_UPDATE=10254 

select * from MDM_CRM_AZS_COMM_RAW_TEST_PHN
where isvalid=0

create table MDM_CRM_AZS_COMM_RAW_TEST_PHN
(
  id            NUMBER(19) not null,
  cdvgsminfo    VARCHAR2(100 CHAR),
  cdvemailinfo  VARCHAR2(100 CHAR),
  mobilephone   VARCHAR2(50 CHAR),
  telephone3    VARCHAR2(50 CHAR),
  emailaddress1 VARCHAR2(50 CHAR),
  runno_update  NUMBER(10) ,
  dahili VARCHAR2(50),
  isvalid number(1),
  telno1 varchar2(300),
  telno2 varchar2(300),
  telno3 varchar2(300)
)


--RUNNOUPDATE: 10254  CNT: 284423 6dk
insert /*+append*/ into MDM_CRM_AZS_COMM_RAW_TEST_PHN
select 
id,
cdvgsminfo,
cdvemailinfo,
mobilephone,
telephone3,
emailaddress1,
runno_update,
fnc_phn_dahili(mobilephone),
fnc_phn_isvalid(mobilephone),
fnc_phn_telno1(mobilephone),
fnc_phn_telno2(mobilephone),
fnc_phn_telno3(mobilephone)
from MDM_CRM_AZS_COMM_RAW_TEST
where 1=1
and RUNNO_UPDATE=10254

commit

create table MDM_CRM_AZS_COMM_RAW_TEST_MAIL
(
  id            NUMBER(19) not null,
  cdvgsminfo    VARCHAR2(100 CHAR),
  cdvemailinfo  VARCHAR2(100 CHAR),
  mobilephone   VARCHAR2(50 CHAR),
  telephone3    VARCHAR2(50 CHAR),
  emailaddress1 VARCHAR2(50 CHAR),
  runno_update  NUMBER(10) ,
  isvalid number(1),
  email_processed varchar2(300),
  email_quality_code varchar2(300)
)



--RUNNOUPDATE: 10254  CNT: 284423 62SN (1DK)
insert /*+append*/ into MDM_CRM_AZS_COMM_RAW_TEST_MAIL
select 
id,
cdvgsminfo,
cdvemailinfo,
mobilephone,
telephone3,
emailaddress1,
runno_update,
fnc_email_isvalid(emailaddress1),
fnc_email_processed(emailaddress1),
fnc_email_quality_code(emailaddress1)
from MDM_CRM_AZS_COMM_RAW_TEST
where 1=1
and RUNNO_UPDATE=10254


create table composecrml1.MDM_CRM_AZS_COMM_RAW_TEST_MT
(
  id            NUMBER(19) not null,
  cdvgsminfo    VARCHAR2(100 CHAR),
  cdvemailinfo  VARCHAR2(100 CHAR),
  mobilephone   VARCHAR2(50 CHAR),
  telephone3    VARCHAR2(50 CHAR),
  emailaddress1 VARCHAR2(50 CHAR),
  runno_update  NUMBER(10) ,
  dahili VARCHAR2(50),
  isvalid_phn number(1),
  telno1 varchar2(300),
  telno2 varchar2(300),
  telno3 varchar2(300),
    isvalid_mail number(1),
  email_processed varchar2(300),
  email_quality_code varchar2(300)
)

--RUNNOUPDATE: 10254  CNT: 284423 449 SN (7DK)
insert /*+append*/ into MDM_CRM_AZS_COMM_RAW_TEST_MT
select 
id,
cdvgsminfo,
cdvemailinfo,
mobilephone,
telephone3,
emailaddress1,
runno_update,
fnc_phn_dahili(mobilephone),
fnc_phn_isvalid(mobilephone),
fnc_phn_telno1(mobilephone),
fnc_phn_telno2(mobilephone),
fnc_phn_telno3(mobilephone),
fnc_email_isvalid(emailaddress1),
fnc_email_processed(emailaddress1),
fnc_email_quality_code(emailaddress1)
from MDM_CRM_AZS_COMM_RAW_TEST
where 1=1
and RUNNO_UPDATE=10254

COMMIT

SELECT * FROM MDM_CRM_AZS_COMM_RAW_TEST_MT

drop table MDM_CRM_AZS_COMM_RAW_TEST_MT purge
drop table  MDM_CRM_AZS_COMM_RAW_TEST_MAIL purge 
drop table MDM_CRM_AZS_COMM_RAW_TEST_PHN purge
