CREATE OR REPLACE PROCEDURE QLICK.PRC_PHN_PROCESS_NUMBER(
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


DECLARE
    in_telefon_numarasi VARCHAR2(100) := '+9005311016093'; -- Provide the actual phone number
    std_tel_no VARCHAR2(100);
    std_tel_no_s VARCHAR2(100);
    lbl_tel_no VARCHAR2(100);

BEGIN
    -- Call the stored procedure
    QLICK.PRC_PHN_PROCESS_NUMBER(in_telefon_numarasi, std_tel_no,std_tel_no_s,lbl_tel_no);

    -- Display the processed phone number
    DBMS_OUTPUT.PUT_LINE('Original Phone Number: ' || in_telefon_numarasi);
    DBMS_OUTPUT.PUT_LINE('Processed Phone Number: ' || std_tel_no);
    DBMS_OUTPUT.PUT_LINE('std_tel_no_s: ' || std_tel_no_s);
    DBMS_OUTPUT.PUT_LINE('Labelled Phone Number: ' || lbl_tel_no);

END;

DECLARE
    in_telefon_numarasi VARCHAR2(50) := '+754-5351016093';  -- Replace with an actual phone number
    dec_dahili_no_out VARCHAR2(50);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
BEGIN
    -- Call the procedure with the provided input
    QLICK.PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);

    -- Display the output using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input Phone Number: ' || in_telefon_numarasi);
    DBMS_OUTPUT.PUT_LINE('Dec Dahili No: ' || dec_dahili_no_out);
    DBMS_OUTPUT.PUT_LINE('Tel No 1: ' || telno1);
    DBMS_OUTPUT.PUT_LINE('Tel No 2: ' || telno2);
    DBMS_OUTPUT.PUT_LINE('Tel No 3: ' || telno3);
END;


INSERT INTO QLICK.REPLACEMENT_TABLE
(SUBJECT, STEP_NAME, RUN_ORDER, SEARCH_STRING, REPLACE_STRING)
VALUES('TEST', 'STEP1-2', 1, '+', '-');  
