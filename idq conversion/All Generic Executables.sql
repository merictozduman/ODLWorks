--------------------------------------------------FUNCTIONS AND DEFINITION TABLES--------------------------------------

CREATE OR REPLACE FUNCTION REPLACE_STRING_BY_TBL(
p_subject_name IN VARCHAR2,   
p_step_name   IN VARCHAR2,
p_input_string IN VARCHAR2
) RETURN VARCHAR2
AS
  v_search_string  VARCHAR2(1000);
  v_replace_string VARCHAR2(1000);
  v_stg_input_string VARCHAR2(1000);
BEGIN
  --  dbms_output.put_line('START-subject_name := '||p_subject_name);
  --  dbms_output.put_line('START-step_name := '||p_step_name);
  --  dbms_output.put_line('START-input_string := '||p_input_string );
	
  v_stg_input_string:=	p_input_string;
  -- Declare a cursor to select rows based on step_name
  FOR c IN (SELECT search_string, replace_string
            FROM replacement_table
            WHERE 1=1 
            AND step_name =p_step_name
            AND subject = p_subject_name
            ORDER BY run_order asc)
  LOOP
    -- Fetch values from the cursor
    v_search_string := c.search_string;
    v_replace_string := c.replace_string;

    -- Perform the replacement for each row
    v_stg_input_string := REPLACE(v_stg_input_string, v_search_string, v_replace_string);
    
--    dbms_output.put_line('v_search_string := '||v_search_string);
--    dbms_output.put_line('v_replace_string := '||v_replace_string);
--    dbms_output.put_line('v_stg_input_string := '||v_stg_input_string );
  END LOOP;
    
  -- Return the final result
  RETURN v_stg_input_string;
END REPLACE_STRING_BY_TBL;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FNC_GET_DOMAIN(email_address Varchar2)
RETURN varchar2
IS 
        at_position NUMBER;
        dot_position NUMBER;
       domain_name varchar2(300);
        
BEGIN 

        at_position := INSTR(email_address, '@');
        
        -- Check if '@' symbol is found
        IF at_position > 0 THEN
		            -- Find the position of the first '.' after '@'
		            dot_position := INSTR(email_address, '.', at_position);
		            -- Check if '.' symbol is found		           
		            IF dot_position > 0 THEN
--		                subdomain_name := SUBSTR(email_address, at_position + 1, dot_position - at_position - 1);
		                domain_name := SUBSTR(email_address, at_position + 1, dot_position - at_position - 1);--SUBSTR(email_address, dot_position + 1);
		            ELSE
		                domain_name := SUBSTR(email_address,INSTR(email_address, '@')+1);
		            END IF;
              ELSE
            domain_name := null;
        END IF;

RETURN domain_name;
END ;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FNC_REVERSE(Str Varchar2)
RETURN varchar2
IS 
    len  NUMBER; 
    StrOut VARCHAR(300); 
BEGIN 

    len := Length(str); 
  
    -- here we starting a loop from max len to 1 
    FOR i IN REVERSE 1.. len LOOP 
        -- assigning the reverse string in str1                
        StrOut := StrOut 
                || Substr(Str, i, 1); 
    END LOOP; 


RETURN StrOut;
END FNC_REVERSE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FNC_ADVANCED_REPLACE(Str Varchar2)
RETURN varchar2
as
    
   type namesarray IS VARRAY(47) OF VARCHAR2(500); 
   names namesarray;   
   StrOut varchar2(300);
BEGIN 
	
   StrOut:=Str;	
   names := namesarray('a','b','c','ç','d','e',
  'f','g','ğ','h','ı','i','j','k','l','m','n','o',
  'ö','p','q','r','s','ş','t','u','ü','v','w','x',
  'y','z','0','1','2','3','4','5','6','7','8','9','@','-','_','.'); 
   

   FOR i IN 1..names.count LOOP
    -- Replace each character from the VARRAY with an empty string
    StrOut := REPLACE(StrOut, names(i), '');
  END LOOP;
  


RETURN StrOut;
END FNC_ADVANCED_REPLACE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION QLICK.FNC_GET_SUBDOMAIN(email_address Varchar2)
RETURN varchar2
IS 
        at_position NUMBER;
        dot_position NUMBER;
        dot_position2 NUMBER;
       subdomain_name varchar2(300);
        
BEGIN 

        at_position := INSTR(email_address, '@');
        
        -- Check if '@' symbol is found
        IF at_position > 0 THEN
		            -- Find the position of the first '.' after '@'
		            dot_position := INSTR(email_address, '.', at_position);
		            dot_position2 := INSTR(email_address, '.', at_position,2);
		            -- Check if '.' symbol is found		           
		            IF dot_position > 0 AND dot_position2>0 THEN
		                subdomain_name := SUBSTR(email_address,dot_position+1,dot_position2-(dot_position+1));
                    ELSIF dot_position > 0 AND dot_position2 =0 THEN
		                subdomain_name := SUBSTR(email_address,dot_position+1);
		               ELSE
		                subdomain_name := null;
		            END IF;
              ELSE
            subdomain_name := null;
        END IF;

RETURN subdomain_name;
END ;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FNC_SEARCH_IN_TABLE(
    p_table_name   IN VARCHAR2,
    p_column_name  IN VARCHAR2,
    p_search_str   IN VARCHAR2
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    -- Use dynamic SQL to execute the query
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table_name ||
                      ' WHERE ' || p_column_name || ' = :search_str'
        INTO v_count
        USING p_search_str;

 
    RETURN v_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL; 
END FNC_SEARCH_IN_TABLE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FNC_TRIM(v_input_string Varchar2)
RETURN varchar2
IS 
   
  v_output_string VARCHAR2(1000);
  v_prev_char      VARCHAR2(1000);
BEGIN 

	  v_output_string := '';

IF v_input_string IS NOT NULL THEN 	 
		  -- Loop through each character in the input string
		  FOR i IN 1..LENGTH(v_input_string)
		  LOOP
		    -- Get the current character
		    v_prev_char := SUBSTR(v_input_string, i, 1);
		
		    -- Append the character to the output string unless it's a space and the previous character was also a space
		    IF v_prev_char NOT IN (' ', CHR(9)) OR  (v_prev_char IN (' ', CHR(9)) AND LENGTH(v_output_string) = 0)  THEN       
		      v_output_string := v_output_string || v_prev_char;
		    END IF;
		  END LOOP;
END IF;

RETURN v_output_string;
END FNC_TRIM;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION LIST_REPLACE(
  inputString  IN VARCHAR2,
  charList      IN VARCHAR2,
  replacement   IN VARCHAR2
) RETURN VARCHAR2
AS
  resultString VARCHAR2(4000);
BEGIN
  resultString := inputString;

  FOR i IN 1..LENGTH(charList) LOOP
    resultString := REPLACE(resultString, SUBSTR(charList, i, 1), replacement);
  END LOOP;

  RETURN resultString;
END LIST_REPLACE;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FNC_SEARCH_EXTENSION(
    p_search_string IN VARCHAR2
) RETURN VARCHAR2
AS
    v_intvalue VARCHAR2(100);
BEGIN
    SELECT INTVALUE
    INTO v_intvalue
    FROM (
        SELECT INTVALUE
        FROM DIC_ALLIANZ_DAHILI_HAT
        WHERE STRINGVALUE LIKE '%' || p_search_string || '%'
        ORDER BY ROWNUM
    )
    WHERE ROWNUM = 1; -- Get the first matching row

    RETURN v_intvalue;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- Return null if no matching record is found
    WHEN OTHERS THEN
        RAISE; -- Propagate other exceptions
END FNC_SEARCH_EXTENSION;

---------------------------------------------------FUNCTIONS AND DEFINITION TABLES END--------------------------------------