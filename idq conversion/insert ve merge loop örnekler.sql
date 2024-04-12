DECLARE
    TYPE phone_number_table IS TABLE OF VARCHAR2(50);
    v_chunk_size CONSTANT NUMBER := 100000;
    v_phone_numbers phone_number_table;

BEGIN
    -- Assuming you have a table named "your_phone_table" with a column "phone_number"
    SELECT phone_number BULK COLLECT INTO v_phone_numbers FROM your_phone_table;

    FOR i IN 1..CEIL(v_phone_numbers.COUNT / v_chunk_size) LOOP
        FOR j IN (i - 1) * v_chunk_size + 1..i * v_chunk_size LOOP
            EXIT WHEN j > v_phone_numbers.COUNT;

            DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
            BEGIN
                QLICK.PRC_PHN_MAIN_PROCESS(
                    v_phone_numbers(j),
                    v_dec_dahili_no,
                    v_telno1,
                    v_telno2,
                    v_telno3
                );

                -- Insert the output into another table (assuming "output_table" exists)
                INSERT INTO output_table VALUES (v_phone_numbers(j), v_dec_dahili_no, v_telno1, v_telno2, v_telno3);
                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    -- Handle exceptions as needed
                    NULL;
            END;
        END LOOP;
    END LOOP;
END;
/


DECLARE
    v_chunk_size CONSTANT NUMBER := 100000;
    v_phone_number VARCHAR2(50);
    v_counter NUMBER := 0;

BEGIN
    FOR rec IN (SELECT phone_number FROM your_phone_table) LOOP
        v_counter := v_counter + 1;

        DECLARE
            v_dec_dahili_no VARCHAR2(300);
            v_telno1 VARCHAR2(300);
            v_telno2 VARCHAR2(300);
            v_telno3 VARCHAR2(300);
        BEGIN
            QLICK.PRC_PHN_MAIN_PROCESS(
                rec.phone_number,
                v_dec_dahili_no,
                v_telno1,
                v_telno2,
                v_telno3
            );

            -- Insert the output into another table (assuming "output_table" exists)
            INSERT INTO output_table VALUES (rec.phone_number, v_dec_dahili_no, v_telno1, v_telno2, v_telno3);
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                -- Handle exceptions as needed
                NULL;
        END;

        -- Check if the chunk size is reached or it's the last iteration
        IF MOD(v_counter, v_chunk_size) = 0 OR v_counter = (SELECT COUNT(*) FROM your_phone_table) THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/


DECLARE
    TYPE phone_number_table IS TABLE OF VARCHAR2(50);
    v_chunk_size CONSTANT NUMBER := 100000;
    v_phone_numbers phone_number_table;

BEGIN
    -- Assuming you have a table named "your_phone_table" with a column "phone_number"
    SELECT phone_number BULK COLLECT INTO v_phone_numbers FROM your_phone_table;

    FOR i IN 1..CEIL(v_phone_numbers.COUNT / v_chunk_size) LOOP
        FOR j IN (i - 1) * v_chunk_size + 1..i * v_chunk_size LOOP
            EXIT WHEN j > v_phone_numbers.COUNT;

            DECLARE
                v_dec_dahili_no VARCHAR2(300);
                v_telno1 VARCHAR2(300);
                v_telno2 VARCHAR2(300);
                v_telno3 VARCHAR2(300);
            BEGIN
                QLICK.PRC_PHN_MAIN_PROCESS(
                    v_phone_numbers(j),
                    v_dec_dahili_no,
                    v_telno1,
                    v_telno2,
                    v_telno3
                );

                -- Use MERGE INTO to update columns in the table (assuming "your_phone_table" exists)
                MERGE INTO your_phone_table tgt
                USING (SELECT v_phone_numbers(j) AS phone FROM dual) src
                ON (tgt.phone_number = src.phone)
                WHEN MATCHED THEN
                    UPDATE SET
                        dec_dahili_no_column = v_dec_dahili_no,
                        telno1_column = v_telno1,
                        telno2_column = v_telno2,
                        telno3_column = v_telno3;

            EXCEPTION
                WHEN OTHERS THEN
                    -- Handle exceptions as needed
                    NULL;
            END;
        END LOOP;
    END LOOP;
END;
/


DECLARE
    v_chunk_size CONSTANT NUMBER := 100000;
    v_phone_number VARCHAR2(50);
    v_counter NUMBER := 0;

BEGIN
    FOR rec IN (SELECT phone_number FROM your_phone_table) LOOP
        v_counter := v_counter + 1;

        DECLARE
            v_dec_dahili_no VARCHAR2(300);
            v_telno1 VARCHAR2(300);
            v_telno2 VARCHAR2(300);
            v_telno3 VARCHAR2(300);
        BEGIN
            QLICK.PRC_PHN_MAIN_PROCESS(
                rec.phone_number,
                v_dec_dahili_no,
                v_telno1,
                v_telno2,
                v_telno3
            );

            -- Use MERGE INTO to update columns in the table (assuming "your_phone_table" exists)
            MERGE INTO your_phone_table tgt
            USING (SELECT rec.phone_number AS phone FROM dual) src
            ON (tgt.phone_number = src.phone)
            WHEN MATCHED THEN
                UPDATE SET
                    dec_dahili_no_column = v_dec_dahili_no,
                    telno1_column = v_telno1,
                    telno2_column = v_telno2,
                    telno3_column = v_telno3;

        EXCEPTION
            WHEN OTHERS THEN
                -- Handle exceptions as needed
                NULL;
        END;

        -- Check if the chunk size is reached or it's the last iteration
        IF MOD(v_counter, v_chunk_size) = 0 OR v_counter = (SELECT COUNT(*) FROM your_phone_table) THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/


ALTER TABLE TEST ADD  dahili VARCHAR2(50) ;
ALTER TABLE TEST ADD  telno1 varchar2(300);
ALTER TABLE TEST ADD  telno2 varchar2(300);
ALTER TABLE  TEST ADD  telno3 varchar2(300);
ALTER TABLE TEST ADD  isvalid number(1);

DECLARE
    in_telefon_numarasi VARCHAR2(50) := '05444325555';  -- Replace with an actual phone number
    dec_dahili_no_out VARCHAR2(50);
    telno1 VARCHAR2(300);
    telno2 VARCHAR2(300);
    telno3 VARCHAR2(300);
    v_valid number(1) ;
BEGIN
    -- Call the procedure with the provided input
    PRC_PHN_MAIN_PROCESS(in_telefon_numarasi, dec_dahili_no_out, telno1, telno2, telno3);

    -- Display the output using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Input Phone Number: ' || nvl(in_telefon_numarasi,0));
    DBMS_OUTPUT.PUT_LINE('Dec Dahili No: ' || nvl(dec_dahili_no_out,0));
    DBMS_OUTPUT.PUT_LINE('Tel No 1: ' || nvl(telno1,0));
    DBMS_OUTPUT.PUT_LINE('Tel No 2: ' || nvl(telno2,0));
    DBMS_OUTPUT.PUT_LINE('Tel No 3: ' || nvl(telno3,0));
    -- Update v_valid based on the conditions
    IF COALESCE(dec_dahili_no_out, '0') || COALESCE(telno1, '0') || COALESCE(telno2, '0') || COALESCE(telno3, '0') = '0000' THEN
        v_valid := 0;
    ELSE
        v_valid := 1;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Valid: ' || v_valid);
END;