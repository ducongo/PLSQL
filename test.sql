
DECLARE
   i CHAR(20);
BEGIN
--    SELECT bank.open_branch('toronto') INTO i
--      FROM dual;
    -- i := bank.open_branch('ottawa');
    --  DBMS_OUTPUT.PUT_LINE(CONCAT('VALUE OPBATAINED IS ',i));
    --  bank.close_branch('kkk');

    bank.open_account('parfait', 'ottawa', 1000000);
    -- bank.transfer('0000001', '0000000', 10);
    -- bank.withdraw('0000000', 5);
    -- UPDATE account SET balance = (balance - 5)  WHERE account.account_number = '0000001';
    -- select * from table(bank.show_branch('ottawa'));
    select * from table(bank.show_all_branches);
    select * from table(bank.show_customer('lyna'));

END;

-- BEGIN

-- bank.close_branch('ottawa');

-- END;
/