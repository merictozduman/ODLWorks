CREATE OR REPLACE PROCEDURE QLICK.PRC_PHN2_PROCESS_NUMBER
AS 
    in_telefon_numarasi  VARCHAR2(300);
    std_tel_no VARCHAR2(300);
    std_tel_no_for_decision VARCHAR2(300);
    lbl_tel_no VARCHAR2(300);
    TYPE StringArray IS TABLE OF VARCHAR2(10);
    Lab_TELNO varchar2(300);
    strings_to_add StringArray := 
    StringArray('00900', '0090', '009', '090', '90', '000', '00', '0', '+00900', '+0090', '+009', '+090', '+90', '+9'
    ,'900','0900','+900','+0900');--ikinci satırdan itibaren benim eklediklerim.
    n NUMBER;
BEGIN

	 in_telefon_numarasi:= FNC_DQ_SPRUNGET_VAL('PHONE',1,'in_telefon_numarasi');
	 Lab_TELNO  := LIST_REPLACE(FNC_TRIM(in_telefon_numarasi)
  												 ,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&''()*+,-./:;<=>?[\]^_`{|}~'
  	                                     		 ,'@');
	
	 std_tel_no  := FNC_TRIM(REPLACE(lab_TELNO,'@',null)) ;
  
    FOR i IN 1..strings_to_add.COUNT LOOP
        n := LENGTH(strings_to_add(i));      
        IF SUBSTR(std_tel_no, 1, n) = strings_to_add(i) THEN
            std_tel_no := 'x' || SUBSTR(std_tel_no, n+1);
        END IF;
    END LOOP;
   
   lbl_tel_no  := LIST_REPLACE(std_tel_no,'0123456789','d') ;
   std_tel_no  := TO_char(tO_NUMBER(SUBSTR(std_tel_no ,INSTR(lbl_tel_no,'d'))));
   std_tel_no_for_decision:= substr(lbl_tel_no,1,INSTR(lbl_tel_no,'d')-1)||std_tel_no;
  
   PRC_DQ_SP_RUN_UPD('PHONE',1,'lbl_tel_no',lbl_tel_no);
   PRC_DQ_SP_RUN_UPD('PHONE',1,'std_tel_no',std_tel_no);
   PRC_DQ_SP_RUN_UPD('PHONE',1,'std_tel_no_for_decision',std_tel_no_for_decision);
   
   PRC_DQ_SP_RUN_UPD('PHONE',2,'p_std_tel_no',std_tel_no);
   PRC_DQ_SP_RUN_UPD('PHONE',3,'in_telefon_numarasi',in_telefon_numarasi);
   PRC_DQ_SP_RUN_UPD('PHONE',4,'lbl_tel_no',lbl_tel_no); 
   PRC_DQ_SP_RUN_UPD('PHONE',4,'std_tel_no_for_decision',std_tel_no_for_decision); 
  
  END ;

----------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_PHN2_MOBILEHOME_CHCK
AS
    p_std_tel_no  VARCHAR2(1000);
    lbl_alan_kodu1 VARCHAR2(1000);
    lbl_alan_kodu2 VARCHAR2(1000);
BEGIN
	 
     p_std_tel_no := FNC_DQ_SPRUNGET_VAL('PHONE',2,'p_std_tel_no');
  
     IF QLICK.FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',SUBSTR(p_std_tel_no, 1, 3))=1 THEN 
        lbl_alan_kodu1:='cep'; 
     ELSE 
       lbl_alan_kodu1:=NULL ;
     END IF;
    

     IF QLICK.FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',SUBSTR(p_std_tel_no, 8, 3))=1 THEN 
        lbl_alan_kodu2:='cep'; 
     ELSE 
        lbl_alan_kodu2:=NULL;
     END IF;

PRC_DQ_SP_RUN_UPD('PHONE',2,'lbl_alan_kodu1',lbl_alan_kodu1);
PRC_DQ_SP_RUN_UPD('PHONE',2,'lbl_alan_kodu2',lbl_alan_kodu2);

PRC_DQ_SP_RUN_UPD('PHONE',4,'lbl_alan_kodu1',lbl_alan_kodu1);
PRC_DQ_SP_RUN_UPD('PHONE',4,'lbl_alan_kodu2',lbl_alan_kodu2);

END ;

----------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure QLICK.PRC_PHN2_EXTENSION_CHCK AS
   in_telefon_numarasi varchar2(1000);
    hat_flag  NUMBER;
    dahili_flag NUMBER;
vStgString1 varchar2(1000);
BEGIN
    
	in_telefon_numarasi:=FNC_DQ_SPRUNGET_VAL('PHONE',3,'in_telefon_numarasi'); 
	vStgString1:=LIST_REPLACE(FNC_TRIM(in_telefon_numarasi)
  												 ,'0123456789!"#$%&''()*+,-./:;<=>?[\]^_`{|}~'
  	                                     		 ,null);  	                                     		
IF vStgString1 IS NULL THEN
 hat_flag:=1;
 dahili_flag :=0;
  ELSE 	
		IF FNC_SEARCH_EXTENSION(vStgString1)='1' THEN
	       hat_flag:=1;
	    else  
	        hat_flag:=0;
	    END IF;
	
		IF FNC_SEARCH_EXTENSION(vStgString1)='0' THEN
	       dahili_flag :=1;
	    else  
	        dahili_flag :=0;
	    END IF; 
END IF;
    
	   PRC_DQ_SP_RUN_UPD('PHONE',3,'hat_flag',hat_flag);    
	   PRC_DQ_SP_RUN_UPD('PHONE',3,'dahili_flag',dahili_flag);
	   PRC_DQ_SP_RUN_UPD('PHONE',4,'hat_flag',hat_flag);    
	   PRC_DQ_SP_RUN_UPD('PHONE',4,'dahili_flag',dahili_flag);

end ;

----------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure QLICK.PRC_PHN2_DECISION AS
lbl_tel_no varchar2(1000);
std_tel_no_for_decision varchar2(1000);
lbl_alan_kodu1 varchar2(1000);
lbl_alan_kodu2  varchar2(1000);
dahili_flag NUMBER;
hat_flag NUMBER;
dec_telefon_no1 varchar2(1000);
dec_telefon_no2 varchar2(1000);
dec_telefon_no3 varchar2(1000);
dec_dahili_no varchar2(1000);
std_tel_no varchar2(300);
BEGIN
	 
	std_tel_no:=FNC_DQ_SPRUNGET_VAL('PHONE',4,'std_tel_no_for_decision'); 
    lbl_tel_no:=FNC_DQ_SPRUNGET_VAL('PHONE',4,'lbl_tel_no');  
	lbl_alan_kodu1 :=FNC_DQ_SPRUNGET_VAL('PHONE',4,'lbl_alan_kodu1');
	lbl_alan_kodu2 :=FNC_DQ_SPRUNGET_VAL('PHONE',4,'lbl_alan_kodu2');
	dahili_flag :=FNC_DQ_SPRUNGET_VAL('PHONE',4,'dahili_flag');
	hat_flag :=FNC_DQ_SPRUNGET_VAL('PHONE',4,'hat_flag');
	
	
IF LENGTH(std_tel_no)<7 THEN --std_tel_no_s
        
        dec_telefon_no1    := '';
        dec_telefon_no2    := '';
        dec_telefon_no3    := '';
        dec_dahili_no      := '';

ELSE

			IF lbl_tel_no='dddddddddd' and dahili_flag=0  THEN
					
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
			
			ELSIF	lbl_tel_no='dddddddddd' and dahili_flag=1  THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,8,3);	
			
			ELSIF	 lbl_tel_no='xdddddddddd' THEN
					  
					 dec_telefon_no1   := SUBSTR(std_tel_no,2,10);
			         dec_telefon_no2   := '';
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';
					
			ELSIF	lbl_tel_no='ddddddd'  THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
			
			ELSIF	 lbl_tel_no='ddd-ddddddd' THEN
					  
					 dec_telefon_no1   := SUBSTR(std_tel_no,1,3) || SUBSTR(std_tel_no,5,7);
			         dec_telefon_no2   := '';
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';		
					 
					
			ELSIF	lbl_tel_no='ddddddddddd'  THEN
					
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,8,4);
					
					ELSIF hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;
			
			ELSIF	 lbl_tel_no='xddd-ddddddd' THEN
					  
					 dec_telefon_no1   := substr(std_tel_no,2,3) || substr(std_tel_no,6,7);
			         dec_telefon_no2   := '';
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';	
			
			ELSIF	 lbl_tel_no='ddddddddd' THEN
					 IF  hat_flag=1 THEN
					 dec_telefon_no1   := substr(std_tel_no,1,7);
			         dec_telefon_no2   := '';
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';	
					 ELSE
					 dec_telefon_no1   := '';
			         dec_telefon_no2   := '';
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';		
					 END IF;
					 	
			ELSIF	lbl_tel_no='dddddddddddd'  THEN
					IF hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					ELSE 
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';			
					END IF;
				
			ELSIF	lbl_tel_no='dddddddddddddd' THEN
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,11,4);	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,8,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					END IF;
					
			ELSIF	lbl_tel_no='ddddddddddddd' THEN
					IF dahili_flag=1 THEN 
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,11,3);		
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;
			
					
			ELSIF 	lbl_tel_no='xddddddddddddd'	THEN
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,3);
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					END IF;
			
			ELSIF	 lbl_tel_no='xddd-ddd-dd-dd' THEN
					  
					 dec_telefon_no1   := substr(std_tel_no,2,3)||substr(std_tel_no,6,3)||substr(std_tel_no,10,2)|| substr(std_tel_no,13,2); 
			         dec_telefon_no2   := '';
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';			
					
			
			ELSIF 	lbl_tel_no='ddddddddddddddd' THEN
					IF dahili_flag=1 THEN 
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,11,5);
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;
					
			ELSIF	 lbl_tel_no='dddddddddd-dddddddddd' THEN					  
					 dec_telefon_no1   := substr(std_tel_no,1,10);
			         dec_telefon_no2   := substr(std_tel_no,12,10);
			         dec_telefon_no3   := '';
			         dec_dahili_no     := '';	
					
			ELSIF 	lbl_tel_no='dddddddd'	THEN
					IF dahili_flag=1 THEN 
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,8,1);
					ELSIF hat_flag=1 THEN 
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF; 
			
			ELSIF 	lbl_tel_no='xddddddddddd'	THEN
					IF  hat_flag=1 THEN 
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF ;
					
			ELSIF 	lbl_tel_no='xddddddd'	THEN			
					dec_telefon_no1    := substr(std_tel_no,2,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='ddddddd-ddddddd'	THEN			
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,9,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					
			ELSIF 	lbl_tel_no='dddddddddd-dd'	THEN	
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,2);	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,1,8) || substr(std_tel_no,12,2);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					END IF;
					
			ELSIF 	lbl_tel_no='xdddddddddddd'	THEN
			
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,2);	
					ELSE
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					END IF;
			
			ELSIF 	lbl_tel_no='dddddddddd-dddd'	THEN			
					IF substr(std_tel_no,1,1)<>'5'  THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,4);	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					END IF;
					
			ELSIF 	lbl_tel_no='dddddddddd-ddd'	THEN			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,3);	
			
			
			ELSIF 	lbl_tel_no='xdddddddddd-ddddddd'	THEN			
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,13,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='xdddddddddd-ddddddddddd' THEN			
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,14,10);	
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
						
			ELSIF 	lbl_tel_no='xdddddddddd-ddd' THEN	
					IF  hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2);	
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSE
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,3);	
					END IF;
					
			ELSIF  lbl_tel_no = 'xdddddddddd-dddd' THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,4);		
					
			ELSIF 	lbl_tel_no = 'dddddddddd-ddddddd' THEN			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,12,7);	
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
			
			ELSIF 	lbl_tel_no='ddddddd-ddddddddddd' THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,10,10);	
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
						
			ELSIF 	lbl_tel_no='dddddddddddddddddd' THEN
					IF substr(std_tel_no,8,1)='0' THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,9,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					ELSE 
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;
					
			ELSIF 	lbl_tel_no='xdddddddddd-dd' THEN
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,2);	
					ELSIF hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSE 
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2);		
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;
			
			ELSIF 	lbl_tel_no='ddddddd-ddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,9,3);
			
				
			ELSIF 	lbl_tel_no='ddd-ddd-dd-dd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,3) || substr(std_tel_no,9,2) || substr(std_tel_no,12,2);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					
					
			ELSIF 	lbl_tel_no='ddddddd-dd' THEN
					IF dahili_flag=1  THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,9,2);		
					ELSIF hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,1,5) || substr(std_tel_no,9,2);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					END IF;
					
			ELSIF 	lbl_tel_no='ddddddd-dddddddddd' THEN
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,9,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,16,3);
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,9,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;
					
			ELSIF 	lbl_tel_no='xddddddddddddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,12,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					
			ELSIF 	lbl_tel_no='dddddddddddddddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,11,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='ddd-dd-dd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,2) || substr(std_tel_no,8,2);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					
			ELSIF 	lbl_tel_no='dddddddddd-ddddddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,13,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='xddddddddddddddddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,13,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					
			ELSIF 	lbl_tel_no='ddd-ddddddd-ddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,3);	
			
			ELSIF 	lbl_tel_no='ddddddd-ddddddd-dddddddddd'  THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,9,7);
			        dec_telefon_no3    := substr(std_tel_no,17,10);
			        dec_dahili_no      := '';			
			
			ELSIF 	lbl_tel_no='xdd-ddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,5,7); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='xdddddddddddddd' THEN
					IF substr(std_tel_no,2,1)='5' THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSE
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,4);
					END IF;
					
			ELSIF 	lbl_tel_no='ddd-ddddddd-dddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := ''; 
			        dec_dahili_no      := substr(std_tel_no,13,4); 	
					
			ELSIF 	lbl_tel_no='xdddddddddd-ddddddd-ddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := substr(std_tel_no,13,7); 
			        dec_telefon_no3    := substr(std_tel_no,21,7); 
			        dec_dahili_no      := '';	
			
			ELSIF 	lbl_tel_no='ddddddddddddddddddddd' THEN
					IF substr(std_tel_no,11,1)<>'0' and dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,11,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,18,4);		
					ELSIF substr(std_tel_no,8,1)='0' and dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,8,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,18,4);	
					ELSIF	substr(std_tel_no,11,1)='0' THEN
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,12,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSE 
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					END IF;		
					
			ELSIF 	lbl_tel_no='ddddddd-ddddddd-ddddddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,7); 
			        dec_telefon_no2    := substr(std_tel_no,9,7); 
			        dec_telefon_no3    := substr(std_tel_no,18,10); 
			        dec_dahili_no      := '';			
			
			ELSIF 	lbl_tel_no='dddddddddd-d' THEN
					IF hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,10) ;
			        dec_telefon_no2    := '' ;
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,10) ;
			        dec_telefon_no2    := substr(std_tel_no,1,9) || substr(std_tel_no,12,1);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					END IF;
					
			ELSIF 	lbl_tel_no='ddd-ddddddd-ddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
			
			ELSIF 	lbl_tel_no='dddddddddd-ddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='ddd-ddd-dddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,3) || substr(std_tel_no,9,4) ;
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='xddd-ddddddd-ddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,14,3);
								
			ELSIF 	lbl_tel_no='xddd-ddddddd-ddddddd' THEN
					dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7);
			        dec_telefon_no2    := substr(std_tel_no,14,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					
					
			ELSIF 	lbl_tel_no='xdddddddddd-dddddddddd' and dahili_flag=0 THEN
			
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,13,10);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
			
			ELSIF 	lbl_tel_no='dddddddddd-dd-dd'	 THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,1,8) || substr(std_tel_no,12,2);
			        dec_telefon_no3    := substr(std_tel_no,1,8) || substr(std_tel_no,15,2);
			        dec_dahili_no      := '';	
			
			ELSIF 	lbl_tel_no='xddd-ddddddd-dddd'  THEN
					dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,14,4);	
				
			ELSIF 	lbl_tel_no='xdddddddddd-ddddd'   THEN
					IF substr(std_tel_no,2,1)<>'5' THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,5);	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';			
					END IF;
				
			ELSIF 	lbl_tel_no='xdddddddddd-d'	 THEN
					IF dahili_flag=1    THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,1); 	
					ELSIF hat_flag=1	THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := substr(std_tel_no,2,9) || substr(std_tel_no,13,1); 
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					END IF;
					
			ELSIF 	lbl_tel_no='xddd-ddddddd-dd'	 THEN
			
					dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,7);
			        dec_telefon_no2    := substr(std_tel_no,2,3) || substr(std_tel_no,6,5) || substr(std_tel_no,14,2); 
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';			
								
			ELSIF 	lbl_tel_no='ddd-ddddddd-dd'	 THEN
					IF hat_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';
					ELSIF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,13,2); 
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7);
			        dec_telefon_no2    := substr(std_tel_no,1,3) || substr(std_tel_no,5,5) || substr(std_tel_no,13,2); 
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';			
					END IF;
					
			ELSIF 	lbl_tel_no='x-ddd-ddd-dddd'	 THEN
			
					dec_telefon_no1    := substr(std_tel_no,3,3) || substr(std_tel_no,7,3) || substr(std_tel_no,11,4);
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					
			ELSIF 	lbl_tel_no='xdddddddddddddddddddd'	  THEN
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,12,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,19,3);	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,2,10);
			        dec_telefon_no2    := substr(std_tel_no,12,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';		
					END IF;
					
			ELSIF 	lbl_tel_no='dddddddddd-ddddddd-dddddddddd'		 THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,10);
			        dec_telefon_no2    := substr(std_tel_no,12,7);
			        dec_telefon_no3    := substr(std_tel_no,20,10);
			        dec_dahili_no      := '';
			
			ELSIF 	lbl_tel_no='ddd-ddddddd-ddddddd' THEN
			
					dec_telefon_no1    := substr(std_tel_no,1,3) || substr(std_tel_no,5,7);
			        dec_telefon_no2    := substr(std_tel_no,13,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
			
			ELSIF 	lbl_tel_no='dddddddddd-ddddddd-ddddddd'   THEN
					dec_telefon_no1    := substr(std_tel_no,1,10); 
			        dec_telefon_no2    := substr(std_tel_no,12,7);
			        dec_telefon_no3    := substr(std_tel_no,20,7);	
			        dec_dahili_no      := '';			
			
			ELSIF 	lbl_tel_no= 'xdddddddddd-dd-dd'	  THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2);
			        dec_telefon_no3    := substr(std_tel_no,2,8) || substr(std_tel_no,16,2);	
			        dec_dahili_no      := '';	
			
			ELSIF lbl_tel_no= 'xddd-ddd-dddd'	  THEN
					dec_telefon_no1    := substr(std_tel_no,2,3) || substr(std_tel_no,6,3)  || substr(std_tel_no,10,4); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
					
			ELSIF lbl_tel_no= 'xdddddddddd-ddddddddddd-ddddddddddd' THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := substr(std_tel_no,14,10); 
			        dec_telefon_no3    := substr(std_tel_no,26,10); 
			        dec_dahili_no      := '';	
			
			ELSIF 	lbl_tel_no='ddddddd-dd-dd'  THEN
					IF dahili_flag=1 THEN
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,1,5) || substr(std_tel_no,9,2);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,2);	
					ELSE
					dec_telefon_no1    := substr(std_tel_no,1,7);
			        dec_telefon_no2    := substr(std_tel_no,1,5) || substr(std_tel_no,9,2);
			        dec_telefon_no3    := substr(std_tel_no,1,5) || substr(std_tel_no,12,2);
			        dec_dahili_no      := '';		
					END IF;		
			ELSIF lbl_tel_no='xdddddddddd-dd-ddd' THEN
				   	dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := substr(std_tel_no,2,8) || substr(std_tel_no,13,2); 
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,16,3); 	
					
			ELSIF lbl_tel_no='dddddddddd-ddddddd-ddddddddddd'		THEN
					dec_telefon_no1    := substr(std_tel_no,1,10); 
			        dec_telefon_no2    := substr(std_tel_no,12,7);
			        dec_telefon_no3    := substr(std_tel_no,21,10); 
			        dec_dahili_no      := '';
			
			ELSIF lbl_tel_no='xdddddddddd-ddddddd-dddd'		THEN
					dec_telefon_no1    := substr(std_tel_no,2,10); 
			        dec_telefon_no2    := substr(std_tel_no,13,7);
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,21,4); 
			
			ELSIF lbl_tel_no='ddd-dddddddddd'		THEN
					dec_telefon_no1    := substr(std_tel_no,1,3)  || substr(std_tel_no,5,7); 
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := substr(std_tel_no,12,3); 	
					
			ELSIF lbl_tel_no='ddddddddddddddddd' THEN 
					IF lbl_alan_kodu1='cep' THEN
			
					dec_telefon_no1    := SUBSTR(std_tel_no,1,10);
					dec_telefon_no2    := SUBSTR(std_tel_no,11,7);
					dec_telefon_no3    := '';
					dec_dahili_no      := '';
					
					ELSIF lbl_alan_kodu2='cep' THEN
			
					dec_telefon_no1	   := SUBSTR(std_tel_no,1,7);
					dec_telefon_no2    := SUBSTR(std_tel_no,8,10);
					dec_telefon_no3    := '';
					dec_dahili_no      := '';
					
					ELSIF lbl_alan_kodu1='ev' THEN
			 
					dec_telefon_no1	   :=SUBSTR(std_tel_no,1,10);
					dec_telefon_no2    :=SUBSTR(std_tel_no,11,7);
					dec_telefon_no3    := '';
					dec_dahili_no      := '';
					
					ELSIF lbl_alan_kodu2='ev' THEN
			
					dec_telefon_no1	   := SUBSTR(std_tel_no,1,7);
					dec_telefon_no2    := SUBSTR(std_tel_no,8,10);
					dec_telefon_no3    := '';
					dec_dahili_no      := '';
					
					ELSE
					dec_telefon_no1	   := '';
					dec_telefon_no2    := '';
					dec_telefon_no3    := '';
					dec_dahili_no      := '';           
					END IF;
				
			ELSE	
			 
					dec_telefon_no1    := '';
			        dec_telefon_no2    := '';
			        dec_telefon_no3    := '';
			        dec_dahili_no      := '';	
			         
			END IF;
 
END IF	;	

PRC_DQ_SP_RUN_UPD('PHONE',4,'dec_telefon_no1',dec_telefon_no1);
PRC_DQ_SP_RUN_UPD('PHONE',4,'dec_telefon_no2',dec_telefon_no2);
PRC_DQ_SP_RUN_UPD('PHONE',4,'dec_telefon_no3',dec_telefon_no3);
PRC_DQ_SP_RUN_UPD('PHONE',4,'dec_dahili_no',dec_dahili_no);

PRC_DQ_SP_RUN_UPD('PHONE',5,'dec_telefon_no1',dec_telefon_no1);
PRC_DQ_SP_RUN_UPD('PHONE',5,'dec_telefon_no2',dec_telefon_no2);
PRC_DQ_SP_RUN_UPD('PHONE',5,'dec_telefon_no3',dec_telefon_no3);
PRC_DQ_SP_RUN_UPD('PHONE',5,'dec_dahili_no',dec_dahili_no);

end ;

-----------------------------------------------------------------------------------------

CREATE OR REPLACE procedure QLICK.PRC_PHN2_VALIDATION AS
 dec_dahili_no_in varchar2(300);  
 dec_telefon_no1 varchar2(300);
 dec_telefon_no2 varchar2(300);
 dec_telefon_no3 varchar2(300);
        dec_dahili_no_out varchar2(300);
		telno1			varchar2(300);
		telno2		    varchar2(300);
		telno3		    varchar2(300);
		telno1_alankodu varchar2(50);
		telno2_alankodu varchar2(50);
		telno3_alankodu varchar2(50);
BEGIN

dec_dahili_no_out:= FNC_DQ_SPRUNGET_VAL('PHONE',5,'dec_dahili_no_in');
dec_telefon_no1  := FNC_DQ_SPRUNGET_VAL('PHONE',5,'dec_telefon_no1');
dec_telefon_no2  := FNC_DQ_SPRUNGET_VAL('PHONE',5,'dec_telefon_no2');
dec_telefon_no3  := FNC_DQ_SPRUNGET_VAL('PHONE',5,'dec_telefon_no3');

-----------------ALAN KODLARI VE TELEFON KODLARINI AYRISTIRIYORUZ------------------------

	IF LENGTH(dec_telefon_no1)=10 THEN
		telno1_alankodu:=SUBSTR(dec_telefon_no1,1,3);
	ELSE   
		telno1_alankodu:='';
	END IF;

	IF LENGTH(dec_telefon_no2)=10 THEN
		telno2_alankodu:=SUBSTR(dec_telefon_no2,1,3);
	ELSE   
		telno2_alankodu:='';
	END IF;

	IF LENGTH(dec_telefon_no3)=10 THEN
		telno3_alankodu:=SUBSTR(dec_telefon_no3,1,3);
	ELSE   
		telno3_alankodu:='';
	END IF;

	IF LENGTH(dec_telefon_no1)=10 THEN
		telno1:=SUBSTR(dec_telefon_no1,4,7);
	ELSE   
		telno1:='';
	END IF;

	IF LENGTH(dec_telefon_no2)=10 THEN
		telno2:=SUBSTR(dec_telefon_no2,4,7);
	ELSE   
		telno2:='';
	END IF;

	IF LENGTH(dec_telefon_no3)=10 THEN
		telno3:=SUBSTR(dec_telefon_no3,4,7);
	ELSE   
		telno3:='';
	END IF;
-----------------------------------END--------------------------------------------------------

-------------------------------AYRISTIRILAN TELEFONLARI VALIDE EDIYORUZ-----------------------


 IF (FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',telno1_alankodu)=1 
			OR FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_SABIT_ALAN_KOD','AREACODE1',telno1_alankodu)=1) 
				AND FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_NOISE_TEL','VALUE2',telno1)=0 
	THEN 
		  telno1:=telno1_alankodu || telno1;
else 	
		  telno1:='';
end IF;

IF (FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',telno2_alankodu)=1 
			OR FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_SABIT_ALAN_KOD','AREACODE1',telno2_alankodu)=1) 
				AND FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_NOISE_TEL','VALUE2',telno2)=0 
	THEN 
		  telno2:=telno2_alankodu || telno2;
else 	
		  telno2:='';
end IF;

IF (FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',telno2_alankodu)=1 
			OR FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_SABIT_ALAN_KOD','AREACODE1',telno2_alankodu)=1) 
				AND FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_NOISE_TEL','VALUE2',telno2)=0 
	THEN 
		  telno3:=telno3_alankodu || telno3;
else 	
		  telno3:='';
end IF;
	
-----------------------------------END--------------------------------------------------------

   PRC_DQ_SP_RUN_UPD('PHONE',5,'dec_dahili_no_out',dec_dahili_no_out);
   PRC_DQ_SP_RUN_UPD('PHONE',5,'telno1',telno1);
   PRC_DQ_SP_RUN_UPD('PHONE',5,'telno2',telno2);
   PRC_DQ_SP_RUN_UPD('PHONE',5,'telno3',telno3);
  
end ;

-----------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_PHN2_MAIN_PROCESS(
    in_telefon_numarasi IN VARCHAR2,
    dec_dahili_no_out OUT VARCHAR2,
    telno1 OUT VARCHAR2,
    telno2 OUT VARCHAR2,
    telno3 OUT VARCHAR2
)
IS
    v_sql varchar2(4000);
BEGIN
	--Başlamadan önce parametre değerlerini sıfırlıyouz.
	UPDATE DQ_SP_RUN_ORDER SET PARAMETER_VALUE=NULL WHERE SUBJECT_NAME ='PHONE';COMMIT; 

    --ilk parametremizi sp_run_order tablomuza işliyoruz. 
    PRC_DQ_SP_RUN_UPD('PHONE',1,'in_telefon_numarasi',in_telefon_numarasi) ; 
   
    --Sırayla job'ları çağırıp, çalıştırıyoruz.
    FOR sp_row IN (SELECT DISTINCT SP_NAME,RUN_ORDER  FROM DQ_SP_RUN_ORDER WHERE SUBJECT_NAME ='PHONE' ORDER BY RUN_ORDER) LOOP
		 v_sql := 'BEGIN ' || sp_row.SP_NAME || '; END;';
		EXECUTE IMMEDIATE v_sql;
    END LOOP;

    --Son stepteki sonuçları, sp_run_order tablosundan okuyup, main_sp değişkenlerine atıyoruz. 
    dec_dahili_no_out :=FNC_DQ_SPRUNGET_VAL('PHONE',5,'dec_dahili_no_out');
    telno1 			  :=FNC_DQ_SPRUNGET_VAL('PHONE',5,'telno1');
    telno2 			  :=FNC_DQ_SPRUNGET_VAL('PHONE',5,'telno2');
    telno3 			  :=FNC_DQ_SPRUNGET_VAL('PHONE',5,'telno3');

END ;

----------------------------TEST PHONE-----------------------------------------------------------------------
--Diğer sp adımları için input değerler DQ_SP_RUN_ORDER tablosuna girilir.çalıştırılan adımın sonucu da aynı tabloya yazar.
--Çalıştırılan adım parametresiz çalıştırılmalıdır. 

DECLARE
    in_telefon_numarasi VARCHAR2(50) := '+9005311016093';  -- Replace with an actual phone number
    dec_dahili_no_out VARCHAR2(50);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN
    -- Call the procedure with the provided input
    QLICK.PRC_PHN2_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);

    -- Display the output using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input Phone Number: ' || in_telefon_numarasi);
    DBMS_OUTPUT.PUT_LINE('Dec Dahili No: ' || dec_dahili_no_out);
    DBMS_OUTPUT.PUT_LINE('Tel No 1: ' || telno1);
    DBMS_OUTPUT.PUT_LINE('Tel No 2: ' || telno2);
    DBMS_OUTPUT.PUT_LINE('Tel No 3: ' || telno3);
END;

----------------------------------------------------------------------------------------------------------------
