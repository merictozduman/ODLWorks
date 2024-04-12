    INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',1,'@@','@');
    INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',2,',@','@');   
    INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',3,'HOTMAIL','HOTMAIL.COM');
    INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',4,'HOTMAİL','HOTMAIL.COM');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',5,'HOTMAİLCOM','HOTMAIL.COM');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',6,'HOTMAILCOM','HOTMAIL.COM');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',7,'GMAİL','GMAIL.COM');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',8,'.coom','.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',9,'superonline','superonline.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',10,'yahoo','yahoo.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',11,'mynet','mynet.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',12,'gmail','gmail.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',13,'hotmail','hotmail.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',14,'gmail','gmail.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',15,'hotmailcom','hotmail.com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',16,'ş','s');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',17,'Ş','s');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',18,'ü','u');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',19,'Ü','u');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',20,'ğ','g');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',21,'Ğ','g');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',22,'ö','o');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',23,'Ö','o');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',24,'ı','i');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',25,'İ','i');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',26,'ç','c');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',27,'Ç','c');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',28,'comtr','com.tr');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',29,'com.com','com');
	INSERT INTO REPLACEMENT_TABLE VALUES('MAIL','STEP1',30,'COM.COM','COM');
	
	

DECLARE
    TYPE StringArray IS TABLE OF VARCHAR2(10);
    strings_to_add StringArray := 
        StringArray('00900', '0090', '009', '090', '90', '000', '00', '0', '+00900', '+0090', '+009', '+090', '+90', '+9');
    target_string VARCHAR2(100) := 'This is a test: +00900 and 0090, but not 900 or 00999. +090 is also here.';
    n NUMBER;
BEGIN
    FOR i IN 1..strings_to_add.COUNT LOOP
        n := LENGTH(strings_to_add(i));
        
        IF SUBSTR(target_string, 1, n) = strings_to_add(i) THEN
            target_string := 'X' || SUBSTR(target_string, n+1);
        END IF;
    END LOOP;

    -- Output the result
    DBMS_OUTPUT.PUT_LINE('Modified String: ' || target_string);
END;
/
-------stringin sonunda, dizideki elemanların uzunluğu kadar yere bakıyor-------------
DECLARE
    TYPE StringArray IS TABLE OF VARCHAR2(10);
    strings_to_add StringArray := 
        StringArray('00900', '0090', '009', '090', '90', '000', '00', '0', '+00900', '+0090', '+009', '+090', '+90', '+9');
    target_string VARCHAR2(100) := 'This is a test: +00900 and 0090, but not 900 or 00999. +090 is also here.';
    n NUMBER;
BEGIN
    FOR i IN 1..strings_to_add.COUNT LOOP
        n := LENGTH(strings_to_add(i));
        
        IF SUBSTR(target_string, -n) = strings_to_add(i) THEN
            target_string := SUBSTR(target_string, 1, LENGTH(target_string) - n) || 'X';
        END IF;
    END LOOP;

    -- Output the result
    DBMS_OUTPUT.PUT_LINE('Modified String: ' || target_string);
END;
/
