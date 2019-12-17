
/*
Student name: Parfait Kingwaya
Student number: 101000644
Course: COMP 4003
Assignment: 1
Date: 9/21/2019
*/

-- Part 1

--Delete tables from database
--=======================

-- DROP TABLE branch;
-- DROP TABLE account;
-- DROP TABLE customer;



-- CREATE TABLE branch (
--     branch_number CHAR(3) PRIMARY KEY,
--     address VARCHAR2(64) NOT NULL,
--     open NUMBER(1) NOT NULL,
--     CHECK(REGEXP_LIKE(BRANCH_NUMBER, '^(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)$')),
--     CHECK(open=0 OR open =1)
-- );

-- CREATE TABLE customer (
--     customer_number CHAR(5) PRIMARY KEY,
--     name VARCHAR2(64) UNIQUE NOT NULL,
--     status NUMBER(1) NOT NULL,
--     open NUMBER(1) NOT NULL,
--     CHECK(REGEXP_LIKE(customer_number, '^(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)$')),
--     CHECK(open=0 OR open =1)
-- );

-- CREATE TABLE account (
--     account_number CHAR(7) PRIMARY KEY,
--     customer_number CHAR(5) NOT NULL,
--     balance INTEGER NOT NULL,
--     open NUMBER(1) NOT NULL,
--     FOREIGN KEY (CUSTOMER_NUMBER) REFERENCES CUSTOMER (CUSTOMER_NUMBER),
--     CHECK(BALANCE >= 0),
--     CHECK(REGEXP_LIKE(ACCOUNT_NUMBER, '^(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)(0|1|2|3|4|5|6|7|8|9)$')),
--     CHECK(open=0 OR open =1)
-- );

-- create or replace type account_record as object (
--   account_number CHAR(7),
--   account_balance INTEGER,
--   branch_total NUMBER,
--   branch_number CHAR(3)
-- );
-- /
-- create or replace type account_record_table as table of account_record;
-- /

create or replace type customer_record as object (
  account_number CHAR(7),
  account_balance INTEGER,
  total_balance NUMBER,
  customer_number CHAR(5)
);
/
create or replace type customer_record_table as table of customer_record;
/


