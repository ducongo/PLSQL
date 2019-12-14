
DECLARE
   i CHAR(20);
BEGIN
--    SELECT bank.open_branch('toronto') INTO i
--      FROM dual;
    -- i := bank.open_branch('ottawa');
    --  DBMS_OUTPUT.PUT_LINE(CONCAT('VALUE OPBATAINED IS ',i));
    --  bank.close_branch('kkk');

    -- bank.open_account('kodesh', 'paris', 10);
    bank.transfer('0000000', '0000001', 5);
    bank.withdraw('0000000', 5);

END;

-- BEGIN

-- bank.close_branch('ottawa');

-- END;
/