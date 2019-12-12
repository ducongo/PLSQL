
DECLARE
   i CHAR(20);
BEGIN
--    SELECT bank.open_branch('toronto') INTO i
--      FROM dual;
    -- i := bank.open_branch('ottawa');
    --  DBMS_OUTPUT.PUT_LINE(CONCAT('VALUE OPBATAINED IS ',i));
    --  bank.close_branch('kkk');

    bank.open_account('lyna', 'paris', 10);
END;

-- BEGIN

-- bank.close_branch('ottawa');

-- END;
/