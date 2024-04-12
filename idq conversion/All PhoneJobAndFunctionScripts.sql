CREATE OR REPLACE PROCEDURE PRC_PHN_PROCESS_NUMBER(
    in_telefon_numarasi  IN  VARCHAR2,
    std_tel_no OUT VARCHAR2,
    std_tel_no_s OUT VARCHAR2,
    lbl_tel_no OUT VARCHAR2
) AS
    TYPE StringArray IS TABLE OF VARCHAR2(10);
    Lab_TELNO varchar2(300);
    strings_to_add StringArray := StringArray(
    '00900',   '0090',  '900','0900', '009', '090', '90', '000', '00', '0', 
    '+00900', '+0090', '+900','+0900','+009', '+090', '+90', '+9' );
    /*
    StringArray('00900', '0090', '009', '090', '90', '000', '00', '0', '+00900', '+0090', '+009', '+090', '+90', '+9'
    ,'900','0900','+900','+0900');--ikinci satırdan itibaren benim eklediklerim.*/
    n NUMBER;
BEGIN
     
	  ---türkçe harf değişimi
      Lab_TELNO  := REPLACE_STRING_BY_TBL('PHONE','STEP1-1',FNC_TRIM(in_telefon_numarasi));
	  --dbms_output.put_line('türkçe harf değişimi: '|| Lab_TELNO  );
    
	 --english alphabet özel karakter değişimi
	  Lab_TELNO  := LIST_REPLACE(FNC_TRIM( Lab_TELNO)
  												 ,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&''*,.:;<=>?[]^_`{|}~'
  	                                     		 ,'@');
      --dbms_output.put_line('english alphabet özel karakter değişimi: '|| Lab_TELNO  );
  	 
     --english alphabet özel karakter değişimi                                    		
     std_tel_no  := REPLACE( Lab_TELNO,'@',null) ;
      --dbms_output.put_line('english alphabet özel karakter değişimi @: '|| std_tel_no  );
     
     --remove -> ()-/\ scope: start
     IF substr(std_tel_no,1,1) IN ('(',')','-','/','\') THEN
	   std_tel_no:=substr(std_tel_no,2,LENGTH(std_tel_no));
	 END IF;  
	--dbms_output.put_line('remove -> ()-/\ scope: start: '|| std_tel_no  );
    
	--replace with x ->00900,0090,009,090,90,000,00,0,+00900,+0090,+009,+090,+90,+9 scope start
    FOR i IN 1..strings_to_add.COUNT LOOP
        n := LENGTH(strings_to_add(i));      
        IF SUBSTR(std_tel_no, 1, n) = strings_to_add(i) THEN
            std_tel_no := 'x' || SUBSTR(std_tel_no, n+1);
        END IF;
    END LOOP;
   	--dbms_output.put_line('replace with x ->00900,0090,009,090... '|| std_tel_no  );
 
            --remove -> + scope: start
     IF substr(std_tel_no,1,1) IN ('+') THEN
	   std_tel_no:=substr(std_tel_no,2,LENGTH(std_tel_no));
	 END IF;  
    --dbms_output.put_line('remove -> + scope: start: '|| std_tel_no  );
   
	--remove ->()-/\+ scope: end
	IF substr(std_tel_no,-1) IN ('(',')','-','/','\','+')  THEN
	   std_tel_no:=substr(std_tel_no,1,LENGTH(std_tel_no)-1);
	END IF;  
    --dbms_output.put_line('remove ->()-/\+ scope: end: '|| std_tel_no  );	

   --replace with '-'  ->   ()-/\+ scope: anywhere
   std_tel_no  := REPLACE_STRING_BY_TBL('PHONE','STEP1-2',FNC_TRIM(std_tel_no));
   --dbms_output.put_line('replace with -  ->   ()-/\+ scope: anywhere: '|| std_tel_no  );	
      
   --replace: '-' -> ------,-----,----,---,-- scope anywhere 
   std_tel_no  := REPLACE_STRING_BY_TBL('PHONE','STEP1-3',FNC_TRIM(std_tel_no)); 
   --dbms_output.put_line('replace: - -> ------,-----,----,---,-- scope anywhere : '|| std_tel_no  );	
  
    --remove '-' scope start
   	IF substr(std_tel_no,1,1)='-' THEN
	   std_tel_no :=substr(std_tel_no  ,2,LENGTH(std_tel_no ));
	END IF;  
    --dbms_output.put_line('remove - scope start '|| std_tel_no  );	

   --remove '-' scope end
	IF substr(std_tel_no ,-1)='-' THEN
	   std_tel_no :=substr(std_tel_no ,1,LENGTH(std_tel_no )-1);
	END IF;  
    --dbms_output.put_line('remove - scope end '|| std_tel_no  );	

   --replace :'x-'->'x' ile değiştir. scope start. 
   IF substr(std_tel_no,1,2)='x-' THEN
      std_tel_no:=REPLACE(std_tel_no,'x-','x');
   END IF;
   --dbms_output.put_line('replace :x-->x ile değiştir. scope start. '|| std_tel_no  );	 

   lbl_tel_no  := LIST_REPLACE(std_tel_no,'0123456789','d') ;
  -- std_tel_no  := std_tel_no 
   std_tel_no_s:= LIST_REPLACE(std_tel_no,'x-()\/',NULL);
END ;

-----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PRC_PHN_MOBILEHOME_CHCK(
    p_std_tel_no IN VARCHAR2,
    lbl_alan_kodu1 OUT VARCHAR2,
    lbl_alan_kodu2 OUT VARCHAR2
)
IS
BEGIN
	

        IF FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',SUBSTR(p_std_tel_no, 1, 3))=1 THEN 
           lbl_alan_kodu1:='cep' ;
        END IF;  
                         
        IF FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_SABIT_ALAN_KOD','AREACODE1',SUBSTR(p_std_tel_no, 1, 3))=1 THEN 
           lbl_alan_kodu1:='ev' ;
        END IF;  
    
	
        IF FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',SUBSTR(p_std_tel_no, 8, 3))=1  THEN
           lbl_alan_kodu2:='cep'; 
        END IF;
       
        IF FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_SABIT_ALAN_KOD','AREACODE1',SUBSTR(p_std_tel_no, 8, 3))=1 THEN
           lbl_alan_kodu2:='ev'; 
        END IF;

       
END PRC_PHN_MOBILEHOME_CHCK;

-----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure PRC_PHN_EXTENSION_CHCK
   ( 
   in_telefon_numarasi IN varchar2,
    hat_flag OUT NUMBER,
    dahili_flag OUT NUMBER
     )
IS
vStgString1 varchar2(300);
BEGIN

	vStgString1:=LIST_REPLACE(FNC_TRIM(in_telefon_numarasi)
  												 ,'0123456789!"#$%&''()*+,-./:;<=>?[\]^_`{|}~'
  	                                     		 ,null);  	                                     		
IF vStgString1 IS NULL THEN
 hat_flag:=0;
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
    
    
end ;

-----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure PRC_PHN_DECISION
   ( 
lbl_tel_no IN varchar2,
std_tel_no IN  varchar2, 
std_tel_no_s IN  varchar2,
lbl_alan_kodu1 IN varchar2, 
lbl_alan_kodu2  IN varchar2,
dahili_flag IN NUMBER,
hat_flag IN NUMBER,
dec_telefon_no1 OUT VARCHAR2,
dec_telefon_no2 OUT VARCHAR2, 
dec_telefon_no3 OUT VARCHAR2,
dec_dahili_no OUT VARCHAR2
     )
IS
BEGIN
	 
	--std_tel_no:=std_tel_no_for_decision;
	
	
IF LENGTH(std_tel_no_s)<7 THEN --std_tel_no_s
        
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

end ;

--------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure PRC_PHN_VALIDATION
   ( 
 dec_dahili_no_in IN varchar2,  
 dec_telefon_no1 IN varchar2,
 dec_telefon_no2 IN varchar2,
 dec_telefon_no3 IN varchar2,
        dec_dahili_no_out out varchar2,
		telno1			OUT varchar2,
		telno2		    OUT varchar2,
		telno3		    OUT varchar2
     )
IS
		telno1_alankodu varchar2(50);
		telno2_alankodu varchar2(50);
		telno3_alankodu varchar2(50);
BEGIN

dec_dahili_no_out:=dec_dahili_no_in;

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
	
end ;

----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure PRC_PHN_PRE_VALIDATION
   ( 
 std_tel_no   IN varchar2 DEFAULT '',  
 std_tel_no_s IN varchar2 DEFAULT '',
 lbl_tel_no   IN varchar2 DEFAULT '',
		chk		out	number
     )
IS
		chk_alankodu varchar2(300);

BEGIN

chk:=0;	
	IF lbl_tel_no='dddddddddd' THEN
		chk_alankodu:=SUBSTR(std_tel_no,1,3);
	END IF;

	IF lbl_tel_no='xdddddddddd' THEN
		chk_alankodu:=SUBSTR(std_tel_no,2,3);
	END IF;
	
		 IF (FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_CEP_ALAN_KOD','AREACODE1',chk_alankodu)=0 
					and FNC_SEARCH_IN_TABLE('DIC_ALLIANZ_SABIT_ALAN_KOD','AREACODE1',chk_alankodu)=0) 
			THEN 
				  chk:=1 ;
		end IF;
		
end ;

----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE QLICK.PRC_PHN_MAIN_PROCESS(
    in_telefon_numarasi IN VARCHAR2,
    dec_dahili_no_out OUT VARCHAR2,
    telno1 OUT VARCHAR2,
    telno2 OUT VARCHAR2,
    telno3 OUT VARCHAR2
)
IS
    std_tel_no VARCHAR2(300);
    std_tel_no_s VARCHAR2(300);
    lbl_tel_no VARCHAR2(300);
    lbl_alan_kodu1 VARCHAR2(300);
    lbl_alan_kodu2 VARCHAR2(300);
    hat_flag NUMBER;
    dahili_flag NUMBER;
    dec_dahili_no_in VARCHAR2(300):='';
    dec_telefon_no1 VARCHAR2(300):='';
    dec_telefon_no2 VARCHAR2(300):='';
    dec_telefon_no3 VARCHAR2(300):='';
	chk number;

   BEGIN

IF FNC_SEARCH_IN_TABLE('MDM_CRM_PHN_STACK','phone',in_telefon_numarasi)=0 THEN 

			    -- trimliyoruz,özel karakterleri çıkatıyoruz. Rakamsal hali std_tel_no içinde xddddddd formatı lbl_tel_no içinde
			    QLICK.PRC_PHN_PROCESS_NUMBER(in_telefon_numarasi, std_tel_no,  std_tel_no_s,lbl_tel_no);
			    QLICK.PRC_PHN_PRE_VALIDATION(std_tel_no,std_tel_no_s,lbl_tel_no,chk);--alan kodu geçersizse hiç işlemeyelim
			   
			   -- dbms_output.put_line('PRC_PHN_PRE_VALIDATION-chk :'||chk);
			   -- dbms_output.put_line('PRC_PHN_PRE_VALIDATION-std_tel_no :'||std_tel_no);
			   -- dbms_output.put_line('PRC_PHN_PRE_VALIDATION-std_tel_no_s :'||std_tel_no_s);
			   -- dbms_output.put_line('PRC_PHN_PRE_VALIDATION-lbl_tel_no :'||lbl_tel_no);
			   
			  IF chk=0 THEN --alan kodu geçersizse hiç işlemeyelim
						/*  
						    dbms_output.put_line('PRC_PHN_PROCESS_NUMBER-in_telefon_numarasi :'||in_telefon_numarasi);
						    dbms_output.put_line('PRC_PHN_PROCESS_NUMBER-std_tel_no :'||std_tel_no);
						    dbms_output.put_line('PRC_PHN_PROCESS_NUMBER-std_tel_no_s :'||std_tel_no_s);
						    dbms_output.put_line('PRC_PHN_PROCESS_NUMBER-lbl_tel_no :'||lbl_tel_no);
						*/
						    -- ev veya cep telefonu olduğunu kontrol ediyoruz
						    QLICK.PRC_PHN_MOBILEHOME_CHCK(std_tel_no_s, lbl_alan_kodu1, lbl_alan_kodu2);
						 /* 
						   dbms_output.put_line('PRC_PHN_MOBILEHOME_CHCK-std_tel_no :'||std_tel_no_s);
						    dbms_output.put_line('PRC_PHN_MOBILEHOME_CHCK-lbl_alan_kodu1 :'||lbl_alan_kodu1);
						    dbms_output.put_line('PRC_PHN_MOBILEHOME_CHCK-lbl_alan_kodu2 :'||lbl_alan_kodu2);
						 */
						   
						    -- dahili veya normal hat mı kontrolu yapıyoruz
						    QLICK.PRC_PHN_EXTENSION_CHCK(in_telefon_numarasi, hat_flag, dahili_flag);
						 /* 
						    dbms_output.put_line('PRC_PHN_EXTENSION_CHCK-in_telefon_numarasi :'||in_telefon_numarasi);
						    dbms_output.put_line('PRC_PHN_EXTENSION_CHCK-hat_flag :'||hat_flag);
						    dbms_output.put_line('PRC_PHN_EXTENSION_CHCK-dahili_flag :'||dahili_flag);
						 */
						   
						    -- yukarıdaki format vef flaglere göre telefon numarasının doğru formatına karar veriliyor
						    QLICK.PRC_PHN_DECISION(lbl_tel_no, std_tel_no, std_tel_no_s, lbl_alan_kodu1, lbl_alan_kodu2, dahili_flag, hat_flag, dec_telefon_no1, dec_telefon_no2, dec_telefon_no3, dec_dahili_no_in);
						  /* 
						    dbms_output.put_line('PRC_PHN_DECISION-lbl_tel_no :'||lbl_tel_no);
						    dbms_output.put_line('PRC_PHN_DECISION-std_tel_no :'||std_tel_no);
						    dbms_output.put_line('PRC_PHN_DECISION-std_tel_no_s :'||std_tel_no_s);
						    dbms_output.put_line('PRC_PHN_DECISION-lbl_alan_kodu1 :'||lbl_alan_kodu1);
						    dbms_output.put_line('PRC_PHN_DECISION-lbl_alan_kodu2 :'||lbl_alan_kodu2);
						    dbms_output.put_line('PRC_PHN_DECISION-dahili_flag :'||dahili_flag);
						    dbms_output.put_line('PRC_PHN_DECISION-hat_flag :'||hat_flag);
						    dbms_output.put_line('PRC_PHN_DECISION-dec_telefon_no1 :'||dec_telefon_no1);
						    dbms_output.put_line('PRC_PHN_DECISION-dec_telefon_no2 :'||dec_telefon_no2);
						    dbms_output.put_line('PRC_PHN_DECISION-dec_telefon_no3 :'||dec_telefon_no3);
						    dbms_output.put_line('PRC_PHN_DECISION-dec_dahili_no_in :'||dec_dahili_no_in);
						  */
						   
						    -- nihai telefon tablosunun alan kodu, alan kod tablolarında, alan kod haric kısmıda noise tablosunda var mı check edilir.
						    QLICK.PRC_PHN_VALIDATION(dec_dahili_no_in, dec_telefon_no1, dec_telefon_no2, dec_telefon_no3, dec_dahili_no_out, telno1, telno2, telno3);
						  /*
						    dbms_output.put_line('PRC_PHN_VALIDATION-dec_dahili_no_in :'||dec_dahili_no_in);
						    dbms_output.put_line('PRC_PHN_VALIDATION-dec_telefon_no1 :'||dec_telefon_no1);
						    dbms_output.put_line('PRC_PHN_VALIDATION-dec_telefon_no2 :'||dec_telefon_no2);
						    dbms_output.put_line('PRC_PHN_VALIDATION-dec_telefon_no3 :'||dec_telefon_no3);
						    dbms_output.put_line('PRC_PHN_VALIDATION-dec_dahili_no_out :'||dec_dahili_no_out);
						    dbms_output.put_line('PRC_PHN_VALIDATION-telno1 :'||telno1);
						    dbms_output.put_line('PRC_PHN_VALIDATION-telno2 :'||telno2);
						    dbms_output.put_line('PRC_PHN_VALIDATION-telno3 :'||telno3);
						   */
						   
						   INSERT INTO MDM_CRM_PHN_STACK VALUES (in_telefon_numarasi,dec_dahili_no_out, telno1, telno2, telno3);COMMIT;
						   --dbms_output.put_line('MDM_CRM_PHN_STACK insert gerçekleşti');
			   END IF;
ELSE

			SELECT dahili INTO dec_dahili_no_out FROM MDM_CRM_PHN_STACK WHERE phone=in_telefon_numarasi;
		    SELECT telno1 INTO telno1 FROM MDM_CRM_PHN_STACK WHERE phone=in_telefon_numarasi;
		    SELECT telno2 INTO telno2 FROM MDM_CRM_PHN_STACK WHERE phone=in_telefon_numarasi; 
		    SELECT telno3 INTO telno3 FROM MDM_CRM_PHN_STACK WHERE phone=in_telefon_numarasi;
		    --dbms_output.put_line('MDM_CRM_PHN_STACK okuma gerçekleşti');
		   
END IF;

END ;

---------------------------------------------------------------------------------------------------------------

DECLARE
    TYPE phone_number_table IS TABLE OF VARCHAR2(300);
    v_chunk_size CONSTANT NUMBER := 100000;
    v_phone_numbers phone_number_table;

BEGIN
    -- Assuming you have a table named "your_phone_table" with a column "phone_number"
    SELECT PHN_NUMBER BULK COLLECT INTO v_phone_numbers FROM test;

    FOR i IN 1..CEIL(v_phone_numbers.COUNT / v_chunk_size) LOOP
	    dbms_output.put_line('i value: '||i);
        FOR j IN (i - 1) * v_chunk_size + 1..i * v_chunk_size LOOP
            EXIT WHEN j > v_phone_numbers.COUNT;

            DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
                 v_valid number(1) ;
            BEGIN
                QLICK.PRC_PHN_MAIN_PROCESS(
                    v_phone_numbers(j),
                    v_dec_dahili_no,
                    v_telno1,
                    v_telno2,
                    v_telno3
                );

                IF COALESCE(v_dec_dahili_no, '0') || COALESCE(v_telno1, '0') || COALESCE(v_telno2, '0') || COALESCE(v_telno3, '0') = '0000' THEN
				        v_valid := 0;
				    ELSE
				        v_valid := 1;
				    END IF;
               
                -- Use MERGE INTO to update columns in the table (assuming "your_phone_table" exists)
                MERGE INTO test tgt
                USING (SELECT v_phone_numbers(j) AS phone FROM dual) src
                ON (tgt.PHN_NUMBER  = src.phone)
                WHEN MATCHED THEN
                    UPDATE SET
                        dahili = v_dec_dahili_no,
                        telno1 = v_telno1,
                        telno2 = v_telno2,
                        telno3 = v_telno3,
                        isvalid=v_valid;
/*
            EXCEPTION
                WHEN OTHERS THEN
                    -- Handle exceptions as needed
                    NULL;
*/                    
            END;
        END LOOP;
    END LOOP;
END;
---------------------------------------------------------------------------------------------------------------------------------------------------

 ---------------------------For Test----------------------

DECLARE
    in_telefon_numarasi VARCHAR2(50) := '+9005311016093';  -- Replace with an actual phone number
    dec_dahili_no_out VARCHAR2(50);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN
    -- Call the procedure with the provided input
    PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);

    -- Display the output using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input Phone Number: ' || in_telefon_numarasi);
    DBMS_OUTPUT.PUT_LINE('Dec Dahili No: ' || dec_dahili_no_out);
    DBMS_OUTPUT.PUT_LINE('Tel No 1: ' || telno1);
    DBMS_OUTPUT.PUT_LINE('Tel No 2: ' || telno2);
    DBMS_OUTPUT.PUT_LINE('Tel No 3: ' || telno3);
END;


----------------------------------------------------------





DECLARE
    v_chunk_size CONSTANT NUMBER := 10000;
    v_phone_number VARCHAR2(50);
    v_counter NUMBER := 0;
    v_cnt_total NUMBER; 

BEGIN
  sELECT COUNT(distinct mobilephone) INTO v_cnt_total FROM composecrml1.tdwh_crm_yasam_comm_raw_hub ;
    FOR rec IN (SELECT distinct mobilephone AS phone_number FROM composecrml1.tdwh_crm_yasam_comm_raw_hub ) LOOP
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
    TYPE phone_number_table IS TABLE OF VARCHAR2(300);
    v_chunk_size CONSTANT NUMBER := 10000;
    v_phone_numbers phone_number_table;

BEGIN
    -- Assuming you have a table named "your_phone_table" with a column "phone_number"
    SELECT PHN_NUMBER BULK COLLECT INTO v_phone_numbers FROM test;

    FOR i IN 1..CEIL(v_phone_numbers.COUNT / v_chunk_size) LOOP
	    dbms_output.put_line('i value: '||i);
        FOR j IN (i - 1) * v_chunk_size + 1..i * v_chunk_size LOOP
            EXIT WHEN j > v_phone_numbers.COUNT;

            DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
                 v_valid number(1) ;
            BEGIN
                QLICK.PRC_PHN_MAIN_PROCESS(
                    v_phone_numbers(j),
                    v_dec_dahili_no,
                    v_telno1,
                    v_telno2,
                    v_telno3
                );

                IF COALESCE(v_dec_dahili_no, '0') || COALESCE(v_telno1, '0') || COALESCE(v_telno2, '0') || COALESCE(v_telno3, '0') = '0000' THEN
				        v_valid := 0;
				    ELSE
				        v_valid := 1;
				    END IF;
               
                -- Use MERGE INTO to update columns in the table (assuming "your_phone_table" exists)
                MERGE INTO test tgt
                USING (SELECT v_phone_numbers(j) AS phone FROM dual) src
                ON (tgt.PHN_NUMBER  = src.phone)
                WHEN MATCHED THEN
                    UPDATE SET
                        dahili = v_dec_dahili_no,
                        telno1 = v_telno1,
                        telno2 = v_telno2,
                        telno3 = v_telno3,
                        isvalid=v_valid;
/*
            EXCEPTION
                WHEN OTHERS THEN
                    -- Handle exceptions as needed
                    NULL;
*/                    
            END;
        END LOOP;
    END LOOP;
END;