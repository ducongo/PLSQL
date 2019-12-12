set serverout ON;
Set serveroutput on
CREATE OR REPLACE PACKAGE bank IS
  FUNCTION get_branch (input_address VARCHAR2) RETURN VARCHAR2;
  FUNCTION open_branch (input_address VARCHAR2) RETURN VARCHAR2;
  PROCEDURE close_branch (input_address VARCHAR2);
  PROCEDURE create_customer (input_name VARCHAR2);
  PROCEDURE open_account (input_customer VARCHAR2, input_address VARCHAR2, input_amount NUMBER);
  PROCEDURE withdraw (input_account VARCHAR2, input_amount NUMBER);
  PROCEDURE deposit (input_account VARCHAR2, input_amount NUMBER);
  PROCEDURE transfer (input_account1 VARCHAR2, input_account2 VARCHAR2, input_amount NUMBER);
  
END bank;
/
CREATE OR REPLACE PACKAGE BODY bank IS
  --Function Implimentation
    FUNCTION get_branch (input_address VARCHAR2) RETURN VARCHAR2 IS 
    resultString CHAR(3);
    
    BEGIN
        SELECT branch_number INTO resultString FROM branch WHERE branch.address = input_address AND branch.open = 1;
        IF resultString IS NULL THEN
            -- DBMS_OUTPUT.PUT_LINE('--------------BRANCH DOES NOT EXIST');
            Return NULL;
        ELSE
            -- DBMS_OUTPUT.PUT_LINE('--------------BRANCH DOES EXIST');
            RETURN resultString;
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            -- DBMS_OUTPUT.PUT_LINE('BRANCH DOES NOT EXIST');
            RETURN NULL;
    END get_branch;

    FUNCTION open_branch (input_address VARCHAR2) RETURN VARCHAR2 IS 
        resultString CHAR(3);
        branch_already_exist EXCEPTION;
    BEGIN
        -- DBMS_OUTPUT.PUT_LINE(CONCAT('RESULT FROM BRANCH()', get_branch(input_address)));
        DBMS_OUTPUT.PUT_LINE('SERIOUSLY TF MANNNNN');
        resultString := get_branch(input_address);
        DBMS_OUTPUT.PUT_LINE('YOOO SERIOUSLY TF');
        IF resultString IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('We are at this level 1');

            BEGIN
                SELECT branch_number INTO resultString FROM branch WHERE branch.open = 0;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    resultString:= NULL;
            END;
            -- IF SQL%FOUND THEN
            --     DBMS_OUTPUT.PUT_LINE('FOR CHRIST SAKE');
            -- ELSE
            --     DBMS_OUTPUT.PUT_LINE('DATA FOUND!!!!!!!!!!!!!!!!!!!!!!!');
            -- END IF;

            IF resultString IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('We are at this level 2');
                UPDATE branch SET address = input_address, open = 1 where branch.branch_number = resultString;
            ELSE
                DBMS_OUTPUT.PUT_LINE('We are at this level 3333');
                
                -- BEGIN
                --     SELECT branch_number INTO resultString FROM branch WHERE branch.open = 0;
                -- EXCEPTION
                --     WHEN NO_DATA_FOUND THEN
                --         resultString:= NULL;
                -- END;
                SELECT MAX(branch_number) INTO resultString FROM branch WHERE branch.open = 1;
                DBMS_OUTPUT.PUT_LINE('VALUE OF HIGHEST');
                DBMS_OUTPUT.PUT_LINE('We are at this level 3333');
                IF resultString IS NOT NULL THEN
                
                    IF TO_NUMBER(resultString) < 10 THEN
                        DBMS_OUTPUT.PUT_LINE('We are at this level 444');
                        resultString := CONCAT('00', TO_CHAR(TO_NUMBER(resultString) + 1));
                    ELSIF TO_NUMBER(resultString) < 100 THEN
                        DBMS_OUTPUT.PUT_LINE('We are at this level 555');
                        resultString := CONCAT('0', TO_CHAR(TO_NUMBER(resultString) + 1));
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('We are at this level 666');
                        resultString := TO_CHAR(TO_NUMBER(resultString) + 1);
                    END iF;
                ELSE
                    resultString:= '000';
                END iF;
                INSERT INTO branch VALUES(resultString, input_address, 1);
            END iF;
            DBMS_OUTPUT.PUT_LINE('BRANCH CREATED');
            RETURN resultString;
        ELSE
            RAISE branch_already_exist;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR OPENING BRANCH');
            raise_application_error (-20100, 'error#' || sqlcode || ' desc: ' || sqlerrm);
            RETURN NULL;

    END open_branch; 

    PROCEDURE close_branch (input_address VARCHAR2) IS
        bnum char(3);
        branch_nonexistant EXCEPTION;
    BEGIN
        bnum := get_branch(input_address);
        DBMS_OUTPUT.PUT_LINE(CONCAT('BNUM IS ', bnum));
        UPDATE branch SET open = 0 where branch.address = input_address;
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('COULD NOT CLOSE BRANCH');
            RAISE branch_nonexistant;
        END IF;
    
    -- EXCEPTION
        -- WHEN branch_nonexistant THEN
        --     DBMS_OUTPUT.PUT_LINE('COULD NOT CLOSE BRANCH EXCEPTION RAISED');
        
    --     WHEN OTHERS THEN
    --         DBMS_OUTPUT.PUT_LINE('COULD NOT CLOSE BRANCH EXCEPTION ISSUE');

    END;

    PROCEDURE create_customer (input_name VARCHAR2) IS
        cnum  CHAR(5);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('BOUT TO CREATE CUSTOMER');
        BEGIN
            SELECT customer_number INTO cnum FROM customer WHERE name = input_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 111');
                cnum:= NULL;
        END;

        IF cnum IS NULL THEN
            cnum := NULL;

            BEGIN
                SELECT customer_number INTO cnum FROM customer WHERE customer.open = 0;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 222');
                    cnum:= NULL;
            END;
            
            IF cnum IS NOT NULL THEN
                INSERT INTO customer VALUES(cnum, input_name, 0, 1);
            ELSE
                cnum := NULL;
                SELECT MAX(customer_number) INTO cnum FROM customer;
                IF cnum IS NOT NULL THEN
                    DBMS_OUTPUT.PUT_LINE(CONCAT('CNUM IS _______________________', cnum));
                    IF TO_NUMBER(cnum) < 10 THEN
                        DBMS_OUTPUT.PUT_LINE('LOOKING AT level 1');
                        cnum := CONCAT('0000', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSIF TO_NUMBER(cnum) < 100 THEN
                        DBMS_OUTPUT.PUT_LINE('LOOKING AT level 2');
                        cnum := CONCAT('000', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSIF TO_NUMBER(cnum) < 1000 THEN
                        DBMS_OUTPUT.PUT_LINE('LOOKING AT level 3');
                        cnum := CONCAT('00', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSIF TO_NUMBER(cnum) < 10000 THEN
                        DBMS_OUTPUT.PUT_LINE('LOOKING AT level 4');
                        cnum := CONCAT('0', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('LOOKING AT level 5');
                        cnum := TO_CHAR(TO_NUMBER(cnum) + 1);
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('LOOKING AT level 6');
                    DBMS_OUTPUT.PUT_LINE(CONCAT('CNUM IS _______________________', cnum));
                    INSERT INTO customer VALUES(cnum, input_name, 0, 1);
                    DBMS_OUTPUT.PUT_LINE('Created customer');
                ELSE
                    DBMS_OUTPUT.PUT_LINE(CONCAT('CNUM IS OOOOOOOOOOOOOO_______________________', cnum));
                    INSERT INTO customer VALUES('00000', input_name, 0, 1);
                END IF;
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE(TO_NUMBER('Customer already exist'));
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR OPENING CUSTOMER');
            raise_application_error (-20100, 'error#' || sqlcode || ' desc: ' || sqlerrm);
    END;

    
    PROCEDURE open_account (input_customer VARCHAR2, input_address VARCHAR2, input_amount NUMBER) IS
        bnum CHAR(3);
        cnum CHAR(5);
        anum CHAR(7);
        highestLocal CHAR(4);
        newLocal CHAR(4);

        branch_nonexistant EXCEPTION;
        customer_notexistant EXCEPTION;
        insufficient_balance EXCEPTION;
    BEGIN
        IF input_amount >= 0 THEN
            SELECT branch_number INTO bnum FROM branch WHERE branch.address = input_address;
            BEGIN
                SELECT branch_number INTO bnum FROM branch WHERE branch.address = input_address;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 222');
                    bnum:= NULL;
            END;

            IF bnum IS NOT NULL THEN
                
                BEGIN
                    SELECT customer_number INTO cnum FROM customer WHERE customer.name = input_customer;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 333333');
                        cnum:= NULL;
                END;
                IF cnum IS NOT NULL THEN

                    BEGIN
                    SELECT account_number INTO anum FROM account WHERE account.open = 0;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 444444');
                            anum:= NULL;
                    END;
                    
                    IF anum IS NOT NULL THEN
                        DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 5555');
                        UPDATE account SET customer_number = cnum, balance = input_amount, open = 1 WHERE account.account_number = anum;
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 6666');
                        SELECT MAX(account_number) INTO anum FROM account WHERE account_number LIKE CONCAT(bnum, '%');
                        IF anum IS NOT NULL THEN
                            DBMS_OUTPUT.PUT_LINE('SHOULD BE HERE 7777');
                            highestLocal := SUBSTR(anum, 4, 4);
                            IF TO_NUMBER(highestLocal) < 10 THEN
                                newLocal := CONCAT('0000', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                            ELSIF TO_NUMBER(highestLocal) < 100 THEN
                                newLocal := CONCAT('000', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                            ELSIF TO_NUMBER(highestLocal) < 1000 THEN
                                newLocal := CONCAT('00', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                            ELSIF TO_NUMBER(highestLocal) < 10000 THEN
                                newLocal := CONCAT('0', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                            ELSE
                                newLocal := TO_CHAR(TO_NUMBER(highestLocal) + 1);
                            END IF;

                            anum := CONCAT(bnum, newLocal);

                            INSERT INTO account VALUES(anum, cnum, input_amount, 1);
                            DBMS_OUTPUT.PUT_LINE(TO_NUMBER('Created account'));
                        ELSE
                            INSERT INTO customer VALUES(CONCAT(bnum, '0000'), cnum, input_amount, 1);
                        END IF;
                    END IF;    
                ELSE
                    DBMS_OUTPUT.PUT_LINE(TO_NUMBER('THE CUSTOMER DOESNT EXIST'));
                    RAISE customer_notexistant;
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE(TO_NUMBER('THE BRANCH DOESNT EXIST'));
                RAISE branch_nonexistant;
            END IF;
            
        ELSE
            DBMS_OUTPUT.PUT_LINE(TO_NUMBER('AMOUNT IS NEGATIVE'));
            RAISE insufficient_balance;
        END IF;
        
    END;

    PROCEDURE withdraw (input_account VARCHAR2, input_amount NUMBER) IS
        account_balance NUMBER;
    BEGIN
        SELECT balance INTO account_balance FROM account WHERE account_number = input_account;
        
        IF account_balance IS NOT NULL THEN
            IF account_balance >= input_amount THEN
                UPDATE account SET balance = (account_balance - input_amount)  WHERE account.account_number = input_account;
                IF SQL%ROWCOUNT = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('COULD WITHDRAW MONEY');
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('WITHDRAW AMOUNT EXCEED ACCOUNT BALANCE!');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('ACCOUNT DOESN:T EXIST');
        END IF;
    END;

    PROCEDURE deposit (input_account VARCHAR2, input_amount NUMBER) IS
        account_balance NUMBER;
    BEGIN
        
        IF input_amount >= 0 THEN
            UPDATE account SET balance = (balance + input_amount)  WHERE account.account_number = input_account;
            IF SQL%ROWCOUNT = 0 THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOESNT EXIST!');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('THE AMOUNT TO DEPOSIT IS NEGATIVE');
        END IF;
    END;

    PROCEDURE transfer (input_account1 VARCHAR2, input_account2 VARCHAR2, input_amount NUMBER) IS
        account1_balance NUMBER;
    BEGIN
        
        IF input_amount >= 0 THEN
            SELECT balance INTO account1_balance FROM account WHERE account_number = input_account1;
            
            IF account1_balance IS NOT NULL THEN
                IF account1_balance >= input_amount THEN
                    UPDATE account SET balance = (balance - input_amount)  WHERE account.account_number = input_account1;
                    IF SQL%ROWCOUNT = 0 THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR OCCURED');
                    ELSE
                        UPDATE account SET balance = (balance + input_amount)  WHERE account.account_number = input_account2;
                        IF SQL%ROWCOUNT = 0 THEN
                            DBMS_OUTPUT.PUT_LINE('ACCOUNT TO DEPOSIT MONEY DOESNT EXIST');
                        END IF;
                    END IF;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('WITHDRAW AMOUNT EXCEED ACCOUNT BALANCE!');
                END IF;
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('THE AMOUNT TO DEPOSIT IS NEGATIVE');
        END IF;
    END;

END bank;
/
