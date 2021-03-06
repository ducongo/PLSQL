set serverout ON;
Set serveroutput on
CREATE OR REPLACE PACKAGE bank IS
  FUNCTION get_branch (input_address VARCHAR2) RETURN VARCHAR2;
  FUNCTION open_branch (input_address VARCHAR2) RETURN VARCHAR2;
  PROCEDURE close_branch (input_address VARCHAR2);
  PROCEDURE create_customer (input_name VARCHAR2);
  PROCEDURE remove_customer (input_name VARCHAR2);
  PROCEDURE open_account (input_customer VARCHAR2, input_address VARCHAR2, input_amount NUMBER);
  PROCEDURE close_account (input_account VARCHAR2);
  PROCEDURE withdraw (input_account VARCHAR2, input_amount NUMBER);
  PROCEDURE deposit (input_account VARCHAR2, input_amount NUMBER);
  PROCEDURE transfer (input_account1 VARCHAR2, input_account2 VARCHAR2, input_amount NUMBER);
  function show_branch(input_address VARCHAR2) return account_record_table;
  function show_all_branches return account_record_table;
  function show_customer(input_name VARCHAR2) return customer_record_table;
  
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

        resultString := get_branch(input_address);
        IF resultString IS NULL THEN

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
                
                BEGIN
                    SELECT MAX(branch_number) INTO resultString FROM branch WHERE branch.open = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        resultString:= NULL;
                END;

                IF resultString IS NOT NULL THEN
                
                    IF TO_NUMBER(resultString) < 10 THEN
                        resultString := CONCAT('00', TO_CHAR(TO_NUMBER(resultString) + 1));
                    ELSIF TO_NUMBER(resultString) < 100 THEN
                        resultString := CONCAT('0', TO_CHAR(TO_NUMBER(resultString) + 1));
                    ELSE
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
        BEGIN
            SELECT customer_number INTO cnum FROM customer WHERE name = input_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cnum:= NULL;
        END;

        IF cnum IS NULL THEN
            cnum := NULL;

            BEGIN
                SELECT customer_number INTO cnum FROM customer WHERE customer.open = 0;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    cnum:= NULL;
            END;
            
            IF cnum IS NOT NULL THEN
                INSERT INTO customer VALUES(cnum, input_name, 0, 1);
            ELSE
                cnum := NULL;
                SELECT MAX(customer_number) INTO cnum FROM customer;
                IF cnum IS NOT NULL THEN
                    IF TO_NUMBER(cnum) < 10 THEN
                        cnum := CONCAT('0000', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSIF TO_NUMBER(cnum) < 100 THEN
                        cnum := CONCAT('000', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSIF TO_NUMBER(cnum) < 1000 THEN
                        cnum := CONCAT('00', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSIF TO_NUMBER(cnum) < 10000 THEN
                        cnum := CONCAT('0', TO_CHAR(TO_NUMBER(cnum) + 1));
                    ELSE
                        cnum := TO_CHAR(TO_NUMBER(cnum) + 1);
                    END IF;
                    INSERT INTO customer VALUES(cnum, input_name, 0, 1);
                ELSE
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

    PROCEDURE remove_customer (input_name VARCHAR2) IS
        cnum  CHAR(5);
        customer_nonexistant EXCEPTION;
    BEGIN
        -- bnum := get_branch(input_address);
        -- DBMS_OUTPUT.PUT_LINE(CONCAT('BNUM IS ', bnum));
        UPDATE customer SET open = 0 where customer.name = input_name;
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('COULD NOT CLOSE BRANCH');
            RAISE customer_nonexistant;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR OPENING CUSTOMER');
            raise_application_error (-20100, 'error#' || sqlcode || ' desc: ' || sqlerrm);
    END;

    PROCEDURE close_account (input_account VARCHAR2) IS
        account_balance  NUMBER;
        account_nonexistant EXCEPTION;
        balance_positive EXCEPTION;
    BEGIN
        -- bnum := get_branch(input_address);
        -- DBMS_OUTPUT.PUT_LINE(CONCAT('BNUM IS ', bnum));
        BEGIN
            SELECT balance INTO account_balance FROM account WHERE account.account_number = input_account;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                account_balance:= NULL;
        END;
        IF account_balance IS NOT NULL THEN
            IF account_balance <= 0 THEN
                UPDATE account SET open = 0 where account.account_number = input_account;
                IF SQL%ROWCOUNT = 0 THEN
                    RAISE account_nonexistant;
                END IF;
            ELSE
                RAISE balance_positive;
            END IF;
        ELSE
            RAISE account_nonexistant;
        END IF;
    -- EXCEPTION
    --     WHEN OTHERS THEN
    --         DBMS_OUTPUT.PUT_LINE('ERROR OPENING CUSTOMER');
    --         raise_application_error (-20100, 'error#' || sqlcode || ' desc: ' || sqlerrm);
    END;

    
    PROCEDURE open_account (input_customer VARCHAR2, input_address VARCHAR2, input_amount NUMBER) IS
        bnum CHAR(3);
        cnum CHAR(5);
        anum CHAR(7);
        highestLocal CHAR(4);
        newLocal CHAR(4);

        branch_nonexistant EXCEPTION;
        customer_nonexistant EXCEPTION;
        insufficient_balance EXCEPTION;
        account_already_exist EXCEPTION;
    BEGIN
        IF input_amount >= 0 THEN
            
            BEGIN
                SELECT branch_number INTO bnum FROM branch WHERE branch.address = input_address;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    bnum:= NULL;
            END;

            IF bnum IS NOT NULL THEN
                
                BEGIN
                    SELECT customer_number INTO cnum FROM customer WHERE customer.name = input_customer OR customer.customer_number = input_customer;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        cnum:= NULL;
                END;
                IF cnum IS NOT NULL THEN

                    anum := NULL;
                
                    BEGIN
                        SELECT account_number INTO anum FROM account WHERE account.customer_number = cnum AND account.account_number LIKE CONCAT(bnum, '%');
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            anum:= NULL;
                    END; 

                    IF anum IS NULL THEN 

                        BEGIN
                        SELECT account_number INTO anum FROM account WHERE account.open = 0;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                anum:= NULL;
                        END;
                        
                        IF anum IS NOT NULL THEN
                            UPDATE account SET customer_number = cnum, balance = input_amount, open = 1 WHERE account.account_number = anum;
                        ELSE
                            SELECT MAX(account_number) INTO anum FROM account WHERE account_number LIKE CONCAT(bnum, '%');
                            IF anum IS NOT NULL THEN
                                highestLocal := SUBSTR(anum, 4, 4);
                                IF TO_NUMBER(highestLocal) < 10 THEN
                                    newLocal := CONCAT('000', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                                ELSIF TO_NUMBER(highestLocal) < 100 THEN
                                    newLocal := CONCAT('00', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                                ELSIF TO_NUMBER(highestLocal) < 1000 THEN
                                    newLocal := CONCAT('0', TO_CHAR(TO_NUMBER(highestLocal) + 1));
                                ELSE
                                    newLocal := TO_CHAR(TO_NUMBER(highestLocal) + 1);
                                END IF;

                                anum := CONCAT(bnum, newLocal);

                                INSERT INTO account VALUES(anum, cnum, input_amount, 1);
                                DBMS_OUTPUT.PUT_LINE('Created account');
                            ELSE
                                INSERT INTO account VALUES(CONCAT(bnum, '0000'), cnum, input_amount, 1);
                            END IF;
                        END IF;
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('ACCOUNT ALREADY EXIST');
                        RAISE account_already_exist;
                    END IF;    
                ELSE
                    DBMS_OUTPUT.PUT_LINE('THE CUSTOMER DOESNT EXIST');
                    RAISE customer_nonexistant;
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('THE BRANCH DOESNT EXIST');
                RAISE branch_nonexistant;
            END IF;
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('AMOUNT IS NEGATIVE');
            RAISE insufficient_balance;
        END IF;
        
    END;

    PROCEDURE withdraw (input_account VARCHAR2, input_amount NUMBER) IS
        account_balance NUMBER;

        insufficient_balance EXCEPTION;
        account_nonexistant EXCEPTION;
        BEGIN

            BEGIN
                SELECT balance INTO account_balance FROM account WHERE account_number = input_account;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    account_balance:= NULL;
            END;
            
            IF account_balance IS NOT NULL THEN
                IF account_balance >= input_amount THEN
                    UPDATE account SET balance = (account_balance - input_amount)  WHERE account.account_number = input_account;
                    IF SQL%ROWCOUNT = 0 THEN
                        DBMS_OUTPUT.PUT_LINE('COULD WITHDRAW MONEY');
                    END IF;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('WITHDRAW AMOUNT EXCEED ACCOUNT BALANCE!');
                    RAISE insufficient_balance;
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOESN:T EXIST');
                RAISE account_nonexistant;
            END IF;
        END;

    PROCEDURE deposit (input_account VARCHAR2, input_amount NUMBER) IS
        account_balance NUMBER;
        insufficient_balance EXCEPTION;
        account_nonexistant EXCEPTION;
    BEGIN
        
        IF input_amount >= 0 THEN
            UPDATE account SET balance = (balance + input_amount)  WHERE account.account_number = input_account;
            IF SQL%ROWCOUNT = 0 THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOESNT EXIST!');
                RAISE account_nonexistant;
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('THE AMOUNT TO DEPOSIT IS NEGATIVE');
            RAISE insufficient_balance;
        END IF;
    END;

    PROCEDURE transfer (input_account1 VARCHAR2, input_account2 VARCHAR2, input_amount NUMBER) IS
        account1_balance NUMBER;
        transfer_error EXCEPTION;
        insufficient_balance EXCEPTION;
        account_nonexistant EXCEPTION;
    BEGIN
        
        IF input_amount >= 0 THEN

            BEGIN
                SELECT balance INTO account1_balance FROM account WHERE account_number = input_account1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    account1_balance:= NULL;
            END;

            
            IF account1_balance IS NOT NULL THEN
                IF account1_balance >= input_amount THEN
                    UPDATE account SET balance = (balance - input_amount)  WHERE account.account_number = input_account1;
                    IF SQL%ROWCOUNT = 0 THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR OCCURED');
                        RAISE transfer_error;
                    ELSE
                        UPDATE account SET balance = (balance + input_amount)  WHERE account.account_number = input_account2;
                        IF SQL%ROWCOUNT = 0 THEN
                            DBMS_OUTPUT.PUT_LINE('ACCOUNT TO DEPOSIT MONEY DOESNT EXIST');
                            RAISE account_nonexistant;
                        END IF;
                    END IF;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('WITHDRAW AMOUNT EXCEED ACCOUNT BALANCE!');
                    RAISE insufficient_balance;
                END IF;
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('THE AMOUNT TO DEPOSIT IS NEGATIVE');
            RAISE insufficient_balance;
        END IF;
    END;

    function show_branch(input_address VARCHAR2) return account_record_table as
        v_ret   account_record_table;
        branch_nonexistant EXCEPTION;
        total_balance NUMBER;
        bnum CHAR(3);
    BEGIN
        -- drop type     account_record_table;
        -- drop type     account_record;
        bnum := get_branch(input_address);
        IF bnum IS NOT NULL THEN
            SELECT SUM(balance) INTO total_balance FROM account WHERE account_number LIKE CONCAT(bnum, '%');

            select account_record(account_number,balance, total_balance, bnum)
            bulk collect into v_ret from account where account_number LIKE CONCAT(bnum, '%');

            return v_ret;

        ELSE
            DBMS_OUTPUT.PUT_LINE('BRANCH DOESNT EXIST IN ORDER TO SHOW ACCOUNTS');
            RAISE branch_nonexistant;
        END IF;
        
    END;

    function show_all_branches return account_record_table as
            v_ret   account_record_table;
            CURSOR branch_addresses IS SELECT address FROM branch;
        BEGIN
            v_ret  := account_record_table();
            FOR branch_record IN branch_addresses
                LOOP
                    DBMS_OUTPUT.PUT_LINE(CONCAT('BRANCH NUMBER IS ', branch_record.address));

                    FOR record in (select * from table(show_branch(branch_record.address)))
                        LOOP
                            v_ret.extend; 
                            v_ret(v_ret.count) := account_record(record.account_number,record.account_balance, record.branch_total, record.branch_number);
                            -- DBMS_OUTPUT.PUT_LINE(record.account_number||' '||record.account_balance||' '||record.branch_total||' '||record.branch_number);
                        END LOOP;
                    
                    -- select account_record(account_number,account_balance, branch_total, branch_number)
                    -- bulk collect into v_ret from table(show_branch(branch_record.address));
        
                END LOOP;

            return v_ret;
        END;

    function show_customer(input_name VARCHAR2) return customer_record_table as
        v_ret   customer_record_table;
        branch_nonexistant EXCEPTION;
        total_balance NUMBER;
        cnum CHAR(5);
        BEGIN

            SELECT customer_number INTO cnum FROM customer WHERE customer.name = input_name OR customer.customer_number = input_name;
            
            IF cnum IS NOT NULL THEN
                SELECT SUM(balance) INTO total_balance FROM account WHERE account.customer_number = cnum;

                select customer_record(account_number,balance, total_balance, cnum)
                bulk collect into v_ret from account where account.customer_number = cnum;

                return v_ret;

            ELSE
                DBMS_OUTPUT.PUT_LINE('CUSTOMER DOESNT EXIST IN ORDER TO SHOW ACCOUNTS');
                RAISE branch_nonexistant;
            END IF;
            
        END;

END bank;
/
