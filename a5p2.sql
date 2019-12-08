set serverout ON;
CREATE OR REPLACE PACKAGE bank IS
  FUNCTION branch (input_address VARCHAR2) RETURN VARCHAR2;
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
    FUNCTION branch (input_address VARCHAR2) RETURN VARCHAR2 IS resultString CHAR(5);
    BEGIN
        SELECT branch_number INTO resultString FROM branch WHERE branch.address = input_address AND branch.open = 1;
        IF resultString IS NULL THEN
            RETURN(NULL);
        ELSE
            RETURN (resultString);
        END IF;
    END branch;

    FUNCTION open_branch (input_address VARCHAR2) RETURN VARCHAR2 IS resultString CHAR(5);
    BEGIN
        
        IF bank.branch (input_address) IS NULL THEN
            SELECT branch_number INTO resultString FROM branch WHERE branch.open = 0;

            IF resultString IS NOT NULL THEN
                UPDATE branch SET address = input_address, open = 1 where branch.branch_number = branch_number;
            ELSE
                SELECT MAX(branch_number) INTO resultString FROM branch WHERE branch.open = 0;
                
                IF TO_NUMBER(resultString, '999') < 10 THEN
                    resultString := CONCAT('00', TO_CHAR(TO_NUMBER(resultString, '999') + 1));
                ELSIF TO_NUMBER(resultString, '999') < 100 THEN
                    resultString := CONCAT('0', TO_CHAR(TO_NUMBER(resultString, '999') + 1));
                ELSE
                    resultString := TO_CHAR(TO_NUMBER(resultString, '999') + 1);
                END iF;
                INSERT INTO branch VALUES(resultString, input_address, 1);
            END iF;
            RETURN(resultString);
        ELSE
            DBMS_OUTPUT.PUT_LINE('COULD NOT OPEN BRANCH');
            RETURN (NULL);
        END IF;
    END open_branch; 

    PROCEDURE close_branch (input_address VARCHAR2) IS
        bnum varchar2(3);
    BEGIN
        UPDATE branch SET open = 1 where branch.address = input_address;
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('COULD NOT CLOSE BRANCH');
        END IF;
    END;

    PROCEDURE create_customer (input_name VARCHAR2) IS
        cnum  varchar2(5);
    BEGIN
        SELECT customer_number INTO cnum FROM customer WHERE name = input_name;
        IF cnum IS NULL THEN
            cnum := NULL;
            SELECT customer_number INTO cnum FROM customer WHERE customer.open = 0;
            IF cnum IS NOT NULL THEN
                INSERT INTO customer VALUES(cnum, input_name, 0, 1);
            ELSE
                cnum := NULL;
                SELECT MAX(customer_number) INTO cnum FROM customer;
                IF cnum IS NOT NULL THEN

                    IF TO_NUMBER(cnum, '999') < 10 THEN
                        cnum := CONCAT('0000', TO_CHAR(TO_NUMBER(cnum, '999') + 1));
                    ELSIF TO_NUMBER(cnum, '999') < 100 THEN
                        cnum := CONCAT('000', TO_CHAR(TO_NUMBER(cnum, '999') + 1));
                    ELSIF TO_NUMBER(cnum, '999') < 1000 THEN
                        cnum := CONCAT('00', TO_CHAR(TO_NUMBER(cnum, '999') + 1));
                    ELSIF TO_NUMBER(cnum, '999') < 10000 THEN
                        cnum := CONCAT('0', TO_CHAR(TO_NUMBER(cnum, '999') + 1));
                    ELSE
                        cnum := TO_CHAR(TO_NUMBER(cnum, '999') + 1);
                    END IF;

                    INSERT INTO customer VALUES(TO_CHAR(TO_NUMBER(cnum, '999') + 1), input_name, 0, 1);
                    DBMS_OUTPUT.PUT_LINE(TO_NUMBER('Created customer'));
                ELSE
                    INSERT INTO customer VALUES('00000', input_name, 0, 1);
                END IF;
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE(TO_NUMBER('Customer already exist'));
        END IF;
    END;

    
    PROCEDURE open_account (input_customer VARCHAR2, input_address VARCHAR2, input_amount NUMBER) IS
        bnum varchar2(3);
        cnum VARCHAR(5);
        anum VARCHAR(7);
        highestLocal VARCHAR2(4);
        newLocal VARCHAR2(4);
    BEGIN
        IF input_amount >= 0 THEN
            SELECT branch_number INTO bnum FROM branch WHERE branch.address = input_address;

            IF bnum IS NOT NULL THEN
                SELECT customer_number INTO cnum FROM customer WHERE customer.customer_number = input_customer OR customer.name = input_customer;

                IF cnum IS NOT NULL THEN
                    SELECT account_number INTO anum FROM account WHERE account.open = 0;
                    IF anum IS NOT NULL THEN
                        UPDATE account SET customer_number = cnum, balance = input_amount, open = 1 WHERE account.account_number = anum;
                    ELSE
                        
                        SELECT MAX(account_number) INTO anum FROM account WHERE account_number LIKE CONCAT(bnum, '%');
                        IF anum IS NOT NULL THEN

                            highestLocal := SUBSTR(anum, 4, 4);
                            IF TO_NUMBER(highestLocal, '999') < 10 THEN
                                newLocal := CONCAT('0000', TO_CHAR(TO_NUMBER(highestLocal, '999') + 1));
                            ELSIF TO_NUMBER(highestLocal, '999') < 100 THEN
                                newLocal := CONCAT('000', TO_CHAR(TO_NUMBER(highestLocal, '999') + 1));
                            ELSIF TO_NUMBER(highestLocal, '999') < 1000 THEN
                                newLocal := CONCAT('00', TO_CHAR(TO_NUMBER(highestLocal, '999') + 1));
                            ELSIF TO_NUMBER(highestLocal, '999') < 10000 THEN
                                newLocal := CONCAT('0', TO_CHAR(TO_NUMBER(highestLocal, '999') + 1));
                            ELSE
                                newLocal := TO_CHAR(TO_NUMBER(SUBSTR(highestLocal, 4, 4), '999') + 1);
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
                END IF;
                DBMS_OUTPUT.PUT_LINE(TO_NUMBER('THE BRANCH DOESNT EXIST'));
            ELSE
                DBMS_OUTPUT.PUT_LINE(TO_NUMBER('THE BRANCH DOESNT EXIST'));
            END IF;
            DBMS_OUTPUT.PUT_LINE(TO_NUMBER('THE BRANCH DOESNT EXIST'));
        ELSE
            DBMS_OUTPUT.PUT_LINE(TO_NUMBER('AMOUNT IS NEGATIVE'));
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
