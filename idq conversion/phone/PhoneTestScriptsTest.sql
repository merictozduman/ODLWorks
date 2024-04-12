
-----------------------------PRC_PHN_PROCESS_NUMBER-----------------------------

DECLARE
    in_telefon_numarasi VARCHAR2(100) := '+9005311016093'; -- Provide the actual phone number
    std_tel_no VARCHAR2(100);
    std_tel_no_for_decision VARCHAR2(100);
    lbl_tel_no VARCHAR2(100);

BEGIN
    -- Call the stored procedure
    QLICK.PRC_PHN_PROCESS_NUMBER(in_telefon_numarasi, std_tel_no,std_tel_no_for_decision,lbl_tel_no);

    -- Display the processed phone number
    DBMS_OUTPUT.PUT_LINE('Original Phone Number: ' || in_telefon_numarasi);
    DBMS_OUTPUT.PUT_LINE('Processed Phone Number: ' || std_tel_no);
    DBMS_OUTPUT.PUT_LINE('std_tel_no_for_decision: ' || std_tel_no_for_decision);
    DBMS_OUTPUT.PUT_LINE('Labelled Phone Number: ' || lbl_tel_no);

END;
-----------------------------PRC_PHN_MOBILEHOME_CHCK-----------------------------
DECLARE
    p_std_tel_no VARCHAR2(100) := '5311016093'; -- Provide the actual phone number
    lbl_alan_kodu1 VARCHAR2(10);
    lbl_alan_kodu2 VARCHAR2(10);
BEGIN
    -- Call the procedure
    QLICK.PRC_PHN_MOBILEHOME_CHCK(p_std_tel_no, lbl_alan_kodu1, lbl_alan_kodu2);

    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' || p_std_tel_no);
    DBMS_OUTPUT.PUT_LINE('Label for Area Code 1: ' || lbl_alan_kodu1);
    DBMS_OUTPUT.PUT_LINE('Label for Area Code 2: ' || lbl_alan_kodu2);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

-----------------------------PRC_PHN_EXTENSION_CHCK-----------------------------
DECLARE
    p_std_tel_no VARCHAR2(100) := '5311016093DAH'; -- Provide the actual phone number
    hat_flag NUMBER(1);
    dahili_flag NUMBER(1);
BEGIN
    -- Call the procedure
    QLICK.PRC_PHN_EXTENSION_CHCK(p_std_tel_no, hat_flag, dahili_flag);

    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' || p_std_tel_no);
    DBMS_OUTPUT.PUT_LINE('hat_flag: ' || hat_flag);
    DBMS_OUTPUT.PUT_LINE('dahili_flag: ' || dahili_flag);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

-----------------------PRC_PHONE_DECISION-------------------------------------------

DECLARE
    -- Declare variables to hold input parameters
    lbl_tel_no_param   VARCHAR2(20) := 'xdddddddddd';
    std_tel_no_param   VARCHAR2(20) := 'x5311016093';
    lbl_alan_kodu1_param VARCHAR2(20) := 'cep';
    lbl_alan_kodu2_param VARCHAR2(20) := '';
    dahili_flag_param   NUMBER := 1;
    hat_flag_param      NUMBER := 0;

    -- Declare variables to hold output parameters
    dec_telefon_no1    VARCHAR2(20);
    dec_telefon_no2    VARCHAR2(20);
    dec_telefon_no3    VARCHAR2(20);
    dec_dahili_no      VARCHAR2(20);

BEGIN
    -- Call the procedure
    QLICK.PRC_PHN_DECISION(
        lbl_tel_no_param,
        std_tel_no_param,
        lbl_alan_kodu1_param,
        lbl_alan_kodu2_param,
        dahili_flag_param,
        hat_flag_param,
        dec_telefon_no1,
        dec_telefon_no2,
        dec_telefon_no3,
        dec_dahili_no
    );

    -- Print the output values
    dbms_output.put_line('dec_telefon_no1: ' || dec_telefon_no1);
    dbms_output.put_line('dec_telefon_no2: ' || dec_telefon_no2);
    dbms_output.put_line('dec_telefon_no3: ' || dec_telefon_no3);
    dbms_output.put_line('dec_dahili_no: ' || dec_dahili_no);
END;

-----------------------PRC_PHN_VALIDATION-------------------------------------------

DECLARE
    v_dec_dahili_no_in   VARCHAR2(50) := '';
    v_dec_telefon_no1    VARCHAR2(50) := '2564567890';
    v_dec_telefon_no2    VARCHAR2(50) := '9876543210';
    v_dec_telefon_no3    VARCHAR2(50) := '5555555555';
    v_dec_dahili_no_out  VARCHAR2(50);
    v_telno1             VARCHAR2(50);
    v_telno2             VARCHAR2(50);
    v_telno3             VARCHAR2(50);
BEGIN
    PRC_PHN_VALIDATION(
        v_dec_dahili_no_in,
        v_dec_telefon_no1,
        v_dec_telefon_no2,
        v_dec_telefon_no3,
        v_dec_dahili_no_out,
        v_telno1,
        v_telno2,
        v_telno3
    );

    -- Display the output using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('dec_dahili_no_out: ' || v_dec_dahili_no_out);
    DBMS_OUTPUT.PUT_LINE('telno1: ' || v_telno1);
    DBMS_OUTPUT.PUT_LINE('telno2: ' || v_telno2);
    DBMS_OUTPUT.PUT_LINE('telno3: ' || v_telno3);
END;

-----------------------------PRC_PHN_MAIN_PROCESS------------------------------------------------
DECLARE
    in_telefon_numarasi VARCHAR2(50) := '+9005311016093';  -- Replace with an actual phone number
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

------------------------------------------END--------------------------------------------------------
-------------------------------------------END ------------------------------------------------------
------------------------------------AşAGISINI DIKKATE ALMAYIN----------------------------------------
-----------------------------------MUSVEDDE start----------------------------------------------------------


-----------------------------PRC_PHONE_STEP1-----------------------------
DECLARE
    in_telefon_numarasi   VARCHAR2(300) := 'Hello, ';
    std_telefon_numarasi VARCHAR2(300);
BEGIN
    PRC_PHONE_STEP1(null, std_telefon_numarasi);
    DBMS_OUTPUT.PUT_LINE('std_telefon_numarası: ' || std_telefon_numarasi);
   IF std_telefon_numarasi IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('null döndü');
   END IF;
END;
-----------------------------PRC_PHONE_STEP2-----------------------------
DECLARE
      in_telefon_numarasi VARCHAR2(300) := '1Hello, ';
    Lab_TELNO VARCHAR2(300);
BEGIN
    PRC_PHONE_STEP2(in_telefon_numarasi, Lab_TELNO);
    DBMS_OUTPUT.PUT_LINE('Lab_TELNO: ' || Lab_TELNO);
   IF Lab_TELNO IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('null döndü');
   END IF;
END;

-----------------------------PRC_PHONE_STEP3-----------------------------
DECLARE
    std_telefon_numarasi   VARCHAR2(300) := '1Hello, ';
    lbl_tel_no VARCHAR2(300);
BEGIN
    PRC_PHONE_STEP3(std_telefon_numarasi, lbl_tel_no);
    DBMS_OUTPUT.PUT_LINE('lbl_tel_no: ' || lbl_tel_no);
   IF lbl_tel_no IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('null döndü');
   END IF;
END;

-----------------------------PRC_PHONE_STEP4-----------------------------

DECLARE
    lab_TELNO   VARCHAR2(300) := '+900123123331 ';
    std_tel_no VARCHAR2(300);
BEGIN
    PRC_PHONE_STEP4(lab_TELNO, std_tel_no);
    DBMS_OUTPUT.PUT_LINE('lbl_tel_no: ' || std_tel_no);
   IF std_tel_no IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('null döndü');
   END IF;
END;

-----------------------------PRC_PHONE_STEP5-----------------------------

--Buna gerek yok gibi.Lazım olursa bu adımı ekleriz.Bu işlem daha önce yapılmıştı

-----------------------------PRC_PHONE_STEP6-----------------------------

DECLARE
    std_tel_no   VARCHAR2(300) := 'x900123123331 ';
    lbl_tel_no   VARCHAR2(300);
BEGIN
    QLICK.PRC_PHONE_STEP6(std_tel_no, lbl_tel_no);
    DBMS_OUTPUT.PUT_LINE('lbl_tel_no: ' || lbl_tel_no);
   IF std_tel_no IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('null döndü');
   END IF;
END;


-----------------------------PRC_PHONE_STEP7-----------------------------

--Buna gerek yok gibi.Lazım olursa bu adımı ekleriz.Bu işlem daha önce yapılmıştı

-----------------------------PRC_PHONE_STEP8-----------------------------

--step2 ve step4 de bu işlem yapılıyor

-----------------------------PRC_PHONE_STEP9-----------------------------

DECLARE
    -- Declare variables to store input and output values
    v_std_tel_no VARCHAR2(20) := '123456789012345'; -- Replace with your actual phone number
    v_alan_kodu_17_1 VARCHAR2(3);
    v_alan_kodu_17_2 VARCHAR2(3);
BEGIN

    -- Call the procedure with the input parameter and retrieve the output parameters
    PRC_PHONE_STEP9(v_std_tel_no, v_alan_kodu_17_1, v_alan_kodu_17_2);

    -- Display the results using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input std_tel_no: ' || v_std_tel_no);
    DBMS_OUTPUT.PUT_LINE('Output alan_kodu_17_1: ' || v_alan_kodu_17_1);
    DBMS_OUTPUT.PUT_LINE('Output alan_kodu_17_2: ' || v_alan_kodu_17_2);
END;

-----------------------------PRC_PHONE_STEP10-----------------------------
/*
5-std_remove_digits adımdaki std_tel_no'yu alıyoruz. 
' ' || std_tel_no || ' '  işlemini yaparak std_tel_no_out'a atıyoruz.
*/

--Bu işlemi gerekirse step9'un içinde yapalım

-----------------------------PRC PHONE STEP11-----------------------------

DECLARE
    -- Declare variables to store input and output values
    v_alan_kodu_17_1 VARCHAR2(3) := '123'; -- Replace with your actual value
    v_alan_kodu_17_2 VARCHAR2(3) := '456'; -- Replace with your actual value
    v_lbl_alan_kodu1 VARCHAR2(10);
    v_TokenizedData2 VARCHAR2(10);
    v_lbl_alan_kodu2 VARCHAR2(10);
    v_TokenizedData VARCHAR2(10);
BEGIN
    -- Call the procedure with the input parameters and retrieve the output parameters
    PRC_PHONE_STEP11(
        v_alan_kodu_17_1,
        v_alan_kodu_17_2,
        v_lbl_alan_kodu1,
        v_TokenizedData2,
        v_lbl_alan_kodu2,
        v_TokenizedData
    );

    -- Display the results using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input alan_kodu_17_1: ' || v_alan_kodu_17_1);
    DBMS_OUTPUT.PUT_LINE('Input alan_kodu_17_2: ' || v_alan_kodu_17_2);
    DBMS_OUTPUT.PUT_LINE('Output lbl_alan_kodu1: ' || v_lbl_alan_kodu1);
    DBMS_OUTPUT.PUT_LINE('Output TokenizedData2: ' || v_TokenizedData2);
    DBMS_OUTPUT.PUT_LINE('Output lbl_alan_kodu2: ' || v_lbl_alan_kodu2);
    DBMS_OUTPUT.PUT_LINE('Output TokenizedData: ' || v_TokenizedData);
END;
/

-----------------------------PRC PHONE STEP12-13-----------------------------

DECLARE
    -- Declare variables to store input and output values
    v_std_tel_no VARCHAR2(20) := '12345067890'; -- Replace with your actual value
    v_hat_flag NUMBER;
    v_dahili_flag NUMBER;
BEGIN
    -- Call the procedure with the input parameter and retrieve the output parameters
    PRC_PHONE_STEP12(v_std_tel_no, v_hat_flag, v_dahili_flag);

    -- Display the results using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input std_tel_no: ' || v_std_tel_no);
    DBMS_OUTPUT.PUT_LINE('Output hat_flag: ' || v_hat_flag);
    DBMS_OUTPUT.PUT_LINE('Output dahili_flag: ' || v_dahili_flag);
END;

-----------------------------PRC PHONE STEP14-----------------------------

DECLARE
    lbl_tel_no             VARCHAR2(100) := 'xdddddddddd-dddddddddd';  -- Modify with desired input
    std_tel_no             VARCHAR2(100) := '123456789012345';  -- Modify with desired input
    std_telefon_numarasi   VARCHAR2(100) := '9876543210987654321';  -- Modify with desired input
    lbl_alan_kodu1         VARCHAR2(100) := 'ev';  -- Modify with desired input
    lbl_alan_kodu2         VARCHAR2(100) := 'ev';  -- Modify with desired input
    dahili_flag            NUMBER := 0;  -- Modify with desired input
    hat_flag               NUMBER := 1;  -- Modify with desired input
    dec_telefon_no1        VARCHAR2(100);
    dec_telefon_no2        VARCHAR2(100);
    dec_telefon_no3        VARCHAR2(100);
    dec_dahili_no          VARCHAR2(100);

BEGIN
    PRC_PHONE_STEP14(
        lbl_tel_no,
        std_tel_no,
        std_telefon_numarasi,
        lbl_alan_kodu1,
        lbl_alan_kodu2,
        dahili_flag,
        hat_flag,
        dec_telefon_no1,
        dec_telefon_no2,
        dec_telefon_no3,
        dec_dahili_no
    );

    DBMS_OUTPUT.PUT_LINE('dec_telefon_no1: ' || dec_telefon_no1);
    DBMS_OUTPUT.PUT_LINE('dec_telefon_no2: ' || dec_telefon_no2);
    DBMS_OUTPUT.PUT_LINE('dec_telefon_no3: ' || dec_telefon_no3);
    DBMS_OUTPUT.PUT_LINE('dec_dahili_no: ' || dec_dahili_no);

END;

-----------------------------PRC PHONE STEP15-----------------------------

DECLARE
  dec_telefon_no1 VARCHAR2(20) := '1234567890';  -- Replace with your test data
  dec_telefon_no2 VARCHAR2(20) := '9876543210';  -- Replace with your test data
  dec_telefon_no3 VARCHAR2(20) := '5551234567';  -- Replace with your test data
  telno1_alankodu VARCHAR2(3);
  telno2_alankodu VARCHAR2(3);
  telno3_alankodu VARCHAR2(3);
  telno1 VARCHAR2(7);
  telno2 VARCHAR2(7);
  telno3 VARCHAR2(7);

BEGIN
  -- Call the PRC_PHONE_STEP15 procedure
  PRC_PHONE_STEP15(
    dec_telefon_no1,
    dec_telefon_no2,
    dec_telefon_no3,
    telno1_alankodu,
    telno2_alankodu,
    telno3_alankodu,
    telno1,
    telno2 ,
    telno3
  );

  -- Display output using DBMS_OUTPUT
  DBMS_OUTPUT.PUT_LINE('Telno1 Alankodu: ' || telno1_alankodu);
  DBMS_OUTPUT.PUT_LINE('Telno2 Alankodu: ' || telno2_alankodu);
  DBMS_OUTPUT.PUT_LINE('Telno3 Alankodu: ' || telno3_alankodu);
  DBMS_OUTPUT.PUT_LINE('Telno1: ' || telno1);
  DBMS_OUTPUT.PUT_LINE('Telno2: ' || telno2);
  DBMS_OUTPUT.PUT_LINE('Telno3: ' || telno3);
END;

-----------------------------PRC PHONE STEP16-----------------------------

DECLARE
    v_telno1_alankodu VARCHAR2(20);
    v_telno2_alankodu VARCHAR2(20);
    v_telno3_alankodu VARCHAR2(20);
    v_telno1          VARCHAR2(20);
    v_telno2          VARCHAR2(20);
    v_telno3          VARCHAR2(20);
    v_lbl_telno1_alan_kodu VARCHAR2(20);
    v_Token_telno1_alan    VARCHAR2(20);
    v_lbl_telno2_alan_kodu VARCHAR2(20);
    v_Token_telno2_alan    VARCHAR2(20);
    v_lbl_telno3_alan_kodu VARCHAR2(20);
    v_Token_telno3_alan    VARCHAR2(20);
    v_lbl_telno1           VARCHAR2(20);
    v_Token_telno1         VARCHAR2(20);
    v_lbl_telno2           VARCHAR2(20);
    v_Token_telno2         VARCHAR2(20);
    v_lbl_telno3           VARCHAR2(20);
    v_Token_telno3         VARCHAR2(20);
BEGIN
    -- Set input parameters
    v_telno1_alankodu := '123';
    v_telno2_alankodu := '456';
    v_telno3_alankodu := '789';
    v_telno1 := '111';
    v_telno2 := '222';
    v_telno3 := '333';

    -- Call the procedure
    PRC_PHONE_STEP16(
        v_telno1_alankodu,
        v_telno2_alankodu,
        v_telno3_alankodu,
        v_telno1,
        v_telno2,
        v_telno3,
        v_lbl_telno1_alan_kodu,
        v_Token_telno1_alan,
        v_lbl_telno2_alan_kodu,
        v_Token_telno2_alan,
        v_lbl_telno3_alan_kodu,
        v_Token_telno3_alan,
        v_lbl_telno1,
        v_Token_telno1,
        v_lbl_telno2,
        v_Token_telno2,
        v_lbl_telno3,
        v_Token_telno3
    );

    -- Display the output parameters
    DBMS_OUTPUT.PUT_LINE('lbl_telno1_alan_kodu: ' || v_lbl_telno1_alan_kodu);
    DBMS_OUTPUT.PUT_LINE('Token_telno1_alan: ' || v_Token_telno1_alan);
    DBMS_OUTPUT.PUT_LINE('lbl_telno2_alan_kodu: ' || v_lbl_telno2_alan_kodu);
    DBMS_OUTPUT.PUT_LINE('Token_telno2_alan: ' || v_Token_telno2_alan);
    DBMS_OUTPUT.PUT_LINE('lbl_telno3_alan_kodu: ' || v_lbl_telno3_alan_kodu);
    DBMS_OUTPUT.PUT_LINE('Token_telno3_alan: ' || v_Token_telno3_alan);
    DBMS_OUTPUT.PUT_LINE('lbl_telno1: ' || v_lbl_telno1);
    DBMS_OUTPUT.PUT_LINE('Token_telno1: ' || v_Token_telno1);
    DBMS_OUTPUT.PUT_LINE('lbl_telno2: ' || v_lbl_telno2);
    DBMS_OUTPUT.PUT_LINE('Token_telno2: ' || v_Token_telno2);
    DBMS_OUTPUT.PUT_LINE('lbl_telno3: ' || v_lbl_telno3);
    DBMS_OUTPUT.PUT_LINE('Token_telno3: ' || v_Token_telno3);
END;
