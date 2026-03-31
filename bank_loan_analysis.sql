-- ================================================
-- BANK LOAN PORTFOLIO ANALYSIS
-- Author: Akash Sasikumar
-- Tools: MySQL
-- ================================================

-- ── DATABASE SETUP ────────────────────────────────

CREATE DATABASE bank_loan_db;
USE bank_loan_db;

-- ── TABLE CREATION ────────────────────────────────

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    occupation VARCHAR(50),
    annual_income DECIMAL(12,2)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type VARCHAR(50),
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    issue_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    payment_date DATE,
    amount_paid DECIMAL(12,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE loan_officers (
    officer_id INT PRIMARY KEY,
    officer_name VARCHAR(100),
    branch VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE loan_applications (
    application_id INT PRIMARY KEY,
    customer_id INT,
    officer_id INT,
    loan_id INT,
    application_date DATE,
    decision VARCHAR(20),
    rejection_reason VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (officer_id) REFERENCES loan_officers(officer_id)
);

-- ── DATA INSERTION ────────────────────────────────

INSERT INTO customers VALUES
(1,'Akash Kumar',28,'Male','Chennai','Engineer',850000),
(2,'Priya Sharma',35,'Female','Mumbai','Doctor',1200000),
(3,'Rahul Verma',42,'Male','Delhi','Business',2000000),
(4,'Sneha Patel',29,'Female','Bangalore','IT',950000),
(5,'Vikram Singh',50,'Male','Hyderabad','Retired',600000),
(6,'Meena Nair',38,'Female','Chennai','Teacher',550000),
(7,'Arjun Das',31,'Male','Pune','Engineer',780000),
(8,'Kavya Reddy',27,'Female','Bangalore','IT',880000),
(9,'Suresh Iyer',45,'Male','Chennai','Business',1500000),
(10,'Divya Menon',33,'Female','Mumbai','Doctor',1100000);

INSERT INTO loan_officers VALUES
(1,'Mr. Ramesh','Chennai Branch','South'),
(2,'Ms. Lakshmi','Mumbai Branch','West'),
(3,'Mr. Ajay','Delhi Branch','North'),
(4,'Ms. Preethi','Bangalore Branch','South');

INSERT INTO loans VALUES
(101,1,'Personal',500000,12.5,36,'2022-01-15','Active'),
(102,2,'Home',5000000,8.5,240,'2021-06-20','Active'),
(103,3,'Car',800000,10.0,60,'2023-03-10','Active'),
(104,4,'Education',300000,9.0,48,'2022-09-01','Closed'),
(105,5,'Personal',200000,13.0,24,'2021-12-01','Closed'),
(106,6,'Home',2500000,8.75,180,'2023-01-15','Active'),
(107,7,'Car',600000,10.5,48,'2022-07-20','Active'),
(108,8,'Personal',150000,14.0,18,'2023-05-10','Active'),
(109,9,'Business',1000000,11.0,60,'2021-08-01','Active'),
(110,10,'Home',4000000,8.25,240,'2022-11-30','Active');

INSERT INTO repayments VALUES
(1001,101,'2022-02-15',16000,'On Time'),
(1002,101,'2022-03-15',16000,'On Time'),
(1003,101,'2022-04-15',16000,'Late'),
(1004,102,'2021-07-20',42000,'On Time'),
(1005,102,'2021-08-20',42000,'On Time'),
(1006,103,'2023-04-10',17000,'On Time'),
(1007,103,'2023-05-10',17000,'Missed'),
(1008,104,'2022-10-01',7000,'On Time'),
(1009,105,'2022-01-01',9500,'Late'),
(1010,106,'2023-02-15',25000,'On Time'),
(1011,107,'2022-08-20',14000,'On Time'),
(1012,108,'2023-06-10',9500,'On Time'),
(1013,109,'2021-09-01',22000,'Late'),
(1014,110,'2022-12-30',38000,'On Time');

INSERT INTO loan_applications VALUES
(201,1,1,101,'2022-01-10','Approved',NULL),
(202,2,2,102,'2021-06-15','Approved',NULL),
(203,3,3,103,'2023-03-05','Approved',NULL),
(204,4,4,104,'2022-08-25','Approved',NULL),
(205,5,1,105,'2021-11-25','Approved',NULL),
(206,6,1,106,'2023-01-10','Approved',NULL),
(207,7,4,107,'2022-07-15','Approved',NULL),
(208,8,4,108,'2023-05-05','Approved',NULL),
(209,9,1,109,'2021-07-25','Approved',NULL),
(210,10,2,110,'2022-11-20','Approved',NULL),
(211,1,1,NULL,'2023-06-01','Rejected','Low Credit Score'),
(212,6,1,NULL,'2023-08-01','Rejected','Insufficient Income');

-- ── ANALYSIS QUERIES ──────────────────────────────

-- Q1: INNER JOIN — Customer + Loan Details
SELECT
    c.customer_name, c.city, c.occupation,
    l.loan_type, l.loan_amount, l.status
FROM customers c
INNER JOIN loans l ON c.customer_id = l.customer_id
ORDER BY l.loan_amount DESC;

-- Q2: LEFT JOIN — Customers Without Loans
SELECT
    c.customer_name, c.city, c.annual_income,
    l.loan_id, l.loan_type
FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;

-- Q3: 3-Table JOIN — Full Repayment History
SELECT
    c.customer_name, l.loan_type, l.loan_amount,
    r.payment_date, r.amount_paid, r.payment_status
FROM customers c
INNER JOIN loans l ON c.customer_id = l.customer_id
INNER JOIN repayments r ON l.loan_id = r.loan_id
ORDER BY c.customer_name, r.payment_date;

-- Q4: 4-Table JOIN — Full Application Summary
SELECT
    c.customer_name, c.annual_income,
    lo.officer_name, lo.branch,
    la.application_date, la.decision, la.rejection_reason,
    l.loan_type, l.loan_amount
FROM loan_applications la
INNER JOIN customers c ON la.customer_id = c.customer_id
INNER JOIN loan_officers lo ON la.officer_id = lo.officer_id
LEFT JOIN loans l ON la.loan_id = l.loan_id
ORDER BY la.application_date;

-- Q5: Defaulter Analysis
SELECT
    c.customer_name, c.city, l.loan_type, l.loan_amount,
    COUNT(r.repayment_id) AS bad_payments,
    SUM(r.amount_paid) AS total_paid
FROM customers c
INNER JOIN loans l ON c.customer_id = l.customer_id
INNER JOIN repayments r ON l.loan_id = r.loan_id
WHERE r.payment_status IN ('Late','Missed')
GROUP BY c.customer_name, c.city, l.loan_type, l.loan_amount
ORDER BY bad_payments DESC;

-- Q6: Officer Performance
SELECT
    lo.officer_name, lo.branch,
    COUNT(la.application_id) AS total_applications,
    SUM(CASE WHEN la.decision='Approved' THEN 1 ELSE 0 END) AS approved,
    SUM(CASE WHEN la.decision='Rejected' THEN 1 ELSE 0 END) AS rejected,
    ROUND(SUM(CASE WHEN la.decision='Approved' THEN 1 ELSE 0 END)*100.0/COUNT(*),1) AS approval_rate
FROM loan_officers lo
LEFT JOIN loan_applications la ON lo.officer_id = la.officer_id
GROUP BY lo.officer_name, lo.branch
ORDER BY approval_rate DESC;

-- Q7: Window Function — Loan Ranking
SELECT
    c.customer_name, l.loan_type, l.loan_amount,
    RANK() OVER (PARTITION BY c.customer_id ORDER BY l.loan_amount DESC) AS loan_rank,
    SUM(l.loan_amount) OVER (PARTITION BY c.customer_id) AS total_exposure
FROM customers c
INNER JOIN loans l ON c.customer_id = l.customer_id;

-- Q8: Subquery — Above Average Loan Customers
SELECT
    c.customer_name, c.occupation, l.loan_amount
FROM customers c
INNER JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_amount > (SELECT AVG(loan_amount) FROM loans)
ORDER BY l.loan_amount DESC;