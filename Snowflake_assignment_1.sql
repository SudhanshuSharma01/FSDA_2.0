USE DATABASE DEMO_DATABASE;

CREATE OR REPLACE TABLE SALES_DATA (
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(20),
    customer_name VARCHAR(40),
    segment VARCHAR(15),
    state VARCHAR(50),
    country VARCHAR(50),
    market VARCHAR(10),
    region VARCHAR(30),
    product_id VARCHAR(20),
    category VARCHAR(30),
    sub_category VARCHAR(40),
    product_name VARCHAR(150),
    sales NUMBER(8,0),
    quantity NUMBER(3,0),
    discount NUMBER(6,3),
    profit NUMBER(10,3),
    shipping_cost NUMBER(10,3),
    order_priority VARCHAR(10),
    year NUMBER(4)
);

select * from SALES_DATA;

DESCRIBE TABLE SALES_DATA;

--#2 Change the Primary key to Order Id Column.
ALTER TABLE SALES_DATA
ADD PRIMARY KEY (order_id);

DESCRIBE TABLE SALES_DATA;

--#3 Check the data type for Order date and Ship date and mention in what data type it should be?
-- From Describe command we get that tha type of order_date and Ship_date is "DATE" as I defined
-- while table creation and also did data cleaning to enforce that.

--#4 Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.
ALTER TABLE SALES_DATA
ADD COLUMN ORDER_EXTRACT NUMBER;

UPDATE SALES_DATA
SET ORDER_EXTRACT = TO_NUMBER(SPLIT(ORDER_ID, '-')[2]);  --USING SPLIT FUNCTION I SEPARATED ORDER_ID AT - AND THEN TAKING 2ND ELEMENT 

SELECT ORDER_ID, ORDER_EXTRACT FROM SALES_DATA;

--#5 Create a new column called Discount Flag and categorize it based on discount.
--  Use ‘Yes’ if the discount is greater than zero else ‘No’.
ALTER TABLE SALES_DATA
ADD COLUMN DISCOUNT_FLAG VARCHAR(5);

UPDATE SALES_DATA
SET DISCOUNT_FLAG = IFF(DISCOUNT>0, 'Yes', 'No');

SELECT DISCOUNT, DISCOUNT_FLAG FROM SALES_DATA;

--#6 Create a new column called process days and calculate how many days it takes
--   for each order id to process from the order to its shipment.
ALTER TABLE SALES_DATA
ADD COLUMN PROCESS_DAYS NUMBER;

UPDATE SALES_DATA
SET PROCESS_DAYS = TIMEDIFF('DAY', ORDER_DATE, SHIP_DATE);

SELECT ORDER_DATE, SHIP_DATE, PROCESS_DAYS FROM SALES_DATA;

--#7 Create a new column called Rating and then based on the Process dates give
--   rating like given below.
--   a. If process days less than or equal to 3days then rating should be 5
--   b. If process days are greater than 3 and less than or equal to 6 then rating
--      should be 4
--   c. If process days are greater than 6 and less than or equal to 10 then rating
--      should be 3
--   d. If process days are greater than 10 then the rating should be 2.
ALTER TABLE SALES_DATA
ADD COLUMN RATING NUMBER;

UPDATE SALES_DATA
SET RATING = IFF(PROCESS_DAYS<=3, 5, IFF((PROCESS_DAYS>3 AND PROCESS_DAYS<=6), 4, IFF((PROCESS_DAYS>6 AND PROCESS_DAYS<=10), 3, 2)));  --NESTED IFF TO ACCOMODATE ALL CONDITIONS

SELECT PROCESS_DAYS, RATING FROM SALES_DATA;