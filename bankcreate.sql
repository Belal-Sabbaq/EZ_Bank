
CREATE DATABASE EZ_Bank;
GO

USE EZ_Bank;

-- Create the basic tables first
CREATE TABLE Authentication (
    Username VARCHAR(50) PRIMARY KEY,
    PasswordHash VARCHAR(255) NOT NULL,
    Salt VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Pno INT UNIQUE NOT NULL,
    AccountStatus VARCHAR(20) NOT NULL,
    UserTYPE VARCHAR(20) NOT NULL
);
CREATE TABLE Bank (
    BankID INT PRIMARY KEY,
    BankName VARCHAR(50) UNIQUE NOT NULL,
    EstablishmentDate DATE NOT NULL,
);
Create Table Bank_Contact_information (
    ContactInformation VARCHAR(255) NOT Null,
    BankID INT,
    Department Varchar(50) NOt Null,
    Foreign KEY (BANKID) REFERENCES Bank(BankID)   
	ON Delete Cascade
	ON Update Cascade
);

CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    BankID INT,
    ManagerID INT,
    BranchName VARCHAR(50) UNIQUE NOT NULL,
    BranchAddress VARCHAR(255) UNIQUE NOT NULL,
    OpeningDate DATE NOT NULL,
    OperatingHours VARCHAR(50) NOT NULL,
	Foreign Key (BankID) References Bank(BankID)
	ON Delete Cascade
	ON Update Cascade
);

CREATE TABLE Employee (
    EmployeeID INT,
    EmployeeType VARCHAR(50) NOT NULL,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Pno INT NOT NULL UNIQUE,
    Vacation_Days_remaining INT NOT NULL,
    Bdate DATE NOT NULL,
    Gender CHAR(1),
    Address VARCHAR(50) NOT NULL,
    SSN INT NOT NULL UNIQUE,
    Martial_State VARCHAR(20) NOT NULL,
    Terminatoin_Date DATETIME DEFAULT NULL,
    Hire_Date DATETIME NOT NULL,
    Working_Hours_Per_week INT NOT NULL,
    Salary INT NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Username VARCHAR(50),
    BranchID INT,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
	ON Delete Cascade
	ON Update Cascade,
    FOREIGN KEY (Username) REFERENCES Authentication(Username)
	ON Delete Cascade
	ON UPDATE Cascade
);
ALTER TABLE Branch
ADD CONSTRAINT FK_Branch_Manager 
FOREIGN KEY (ManagerID)
REFERENCES Employee(EmployeeID);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    PhoneNumber VARCHAR(20) NOT NULL Unique,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    SSN VARCHAR(20) NOT NULL Unique,
    MaritalStatus VARCHAR(20) NOT NULL,
    Occupation VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    AnnualIncome DECIMAL(18, 2) NOT NULL,
    RegistrationDate DATE NOT NULL,
    LastLoginDate DATE NOT NULL,
    Email VARCHAR(50) NOT NULL Unique,
    BranchID INT,
    Username VARCHAR(50),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
	ON Delete Cascade
	ON Update Cascade,
    FOREIGN KEY (Username) REFERENCES Authentication(Username)
	ON Delete Cascade
	ON Update Cascade
);

-- Create the Transactions table without foreign key constraints
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    Fees DECIMAL(18, 2) NOT NULL,
    ReferenceNumbers INT NOT NULL UNIQUE,
    TransactionDate DATETIME NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Processing',
    Type VARCHAR(10) NOT NULL,
    Currency VARCHAR(20) NOT NULL DEFAULT 'EGP',
    SendingAccountID INT,
    ReceivingAccountID INT
);

-- Create the Account table without foreign key constraints
CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    InterestRate INT NOT NULL,
    AccountType varchar(50) NOT NULL,
    Balance DECIMAL(18, 2) NOT NULL,
    OpenDate DATE NOT NULL,
    MonthlyStatementDate DATE NOT NULL,
    AccountStatus VARCHAR(20) NOT NULL,
    OverdraftLimit DECIMAL(18, 2) NOT NULL,
    LastTransactionDate DATE NOT NULL,
    Iscore DECIMAL(18, 2) NOT NULL,
    Freezed Bit NOT NULL,
    ActionType VARCHAR(50) NOT NULL,
    ActionDate DATE NOT NULL,
    BankID INT NOT NULL,
    ActionByID INT Default NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (BankID) REFERENCES Bank(BANKID)
	ON Delete NO ACTION
	ON Update No ACTION,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	ON Delete Cascade
	ON Update Cascade,
    FOREIGN KEY (ActionByID) REFERENCES Employee(EmployeeID)
	ON Delete NO ACTION
	ON Update NO ACTION
);

CREATE TABLE CreditCard (
    CardNumber INT PRIMARY KEY,
    ExpirationDate DATE,
    CVV INT,
    CreditLimit DECIMAL(18, 2),
    AvailableCredit DECIMAL(18, 2),
    PaymentDueDate DATE,
    AccountID INT,
    RequestID INT Unique NOT NULL,
    HandledBY INT NOT NULL DEFAULT NULL,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
	ON Delete Cascade
	ON Update Cascade,
    Foreign key (HandledBY) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Loan (
    LoanAmount DECIMAL(18, 2),
    LoanType VARCHAR(50),
    LoanStatus VARCHAR(20),
    OutstandingBalance DECIMAL(18, 2),
    PaymentAmount DECIMAL(18, 2),
    PaymentFrequency VARCHAR(20),
    LoanTerm INT,
    InterestRate DECIMAL(5, 2),
    RequestID INT Unique NOT NULL,
    HandledBY INT NOT NULL DEFAULT NULL,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	On Delete Cascade
	On Update Cascade,
    Foreign key (HandledBY) REFERENCES Employee(EmployeeID)

);



CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY,
    Category VARCHAR(50) NOT NULL,
    Priority VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    DateCreated DATETIME NOT NULL,
    LastUpdated DATETIME NOT NULL,
    LastUpdateEmployeeID INT,
    ReservedToEmployeeID INT,
    SubmittingCustomerID INT,
    FOREIGN KEY (LastUpdateEmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ReservedToEmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (SubmittingCustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Instructions (
    InstructionID INT PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Amount INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    Recipient INT,
    Description VARCHAR(255) NOT NULL,
    DateCreated DATETIME NOT NULL,
    InstructorID INT,
    InstructedEmployeeID INT,
    FOREIGN KEY (Recipient) REFERENCES Account(AccountID)
	ON Delete NO ACTION
	ON UPDATE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (InstructedEmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Reports (
    ReportID INT PRIMARY KEY,
    Category VARCHAR(50) NOT NULL,
    DateGenerated DATETIME NOT NULL,
    Format VARCHAR(10) NOT NULL,
    File_Link VARCHAR(MAX) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    SubmitterEmployeeID INT,
    FOREIGN KEY (SubmitterEmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Attendance (
	AttendanceID INT,
    EmployeeID INT,
    Date DATE NOT NULL,
    TimeIn TIME NOT NULL DEFAULT '00:00',
    TimeOut TIME NOT NULL DEFAULT '00:00',
    Status VARCHAR(20),
    PRIMARY KEY (AttendanceID, Date),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
-- Transactions Table
INSERT INTO Transactions (TransactionID, Fees, ReferenceNumbers, TransactionDate, Amount, Status, Type, Currency, SendingAccountID, ReceivingAccountID)
VALUES
(1, 10.00, 123456, '2023-12-05 12:30:00', 1000.00, 'Completed', 'Deposit', 'USD', 101, NULL),
(2, 5.00, 654321, '2023-11-28 14:45:00', 500.00, 'Processing', 'Withdrawal', 'USD', 102, NULL),
(3, 15.00, 987654, '2023-11-30 10:15:00', 1500.00, 'Completed', 'Transfer', 'USD', 103, 104),
(4, 8.00, 111222, '2023-12-02 16:20:00', 800.00, 'Processing', 'Withdrawal', 'USD', 105, NULL),
(5, 12.50, 333444, '2023-11-25 09:55:00', 1200.00, 'Completed', 'Deposit', 'USD', 101, NULL);

-- Account Table
INSERT INTO Account (AccountID, InterestRate, AccountType, Balance, OpenDate, MonthlyStatementDate, AccountStatus, OverdraftLimit, LastTransactionDate, Iscore, Freezed, ActionType, ActionDate, BankID, ActionByID, CustomerID)
VALUES
(101, 5, 'Savings', 5000.00, '2020-01-15', '2023-12-05', 'Active', 2000.00, '2023-12-05', 800.00, 0, 'Deposit', '2023-12-05', 1, 101, 1),
(102, 3, 'Checking', 2500.00, '2015-03-20', '2023-11-28', 'Active', 1000.00, '2023-11-28', 1200.00, 0, 'Withdrawal', '2023-11-28', 2, 102, 2),
(103, 6, 'Fixed Deposit', 10000.00, '2018-06-10', '2023-11-30', 'Active', 3000.00, '2023-11-30', 1500.00, 0, 'Transfer', '2023-11-30', 3, 103, 3),
(104, 4, 'Checking', 3000.00, '2017-09-01', '2023-12-02', 'Active', 1500.00, '2023-12-02', 600.00, 0, 'Withdrawal', '2023-12-02', 4, 104, 4),
(105, 7, 'Savings', 7000.00, '2012-02-28', '2023-11-25', 'Active', 2500.00, '2023-11-25', 1000.00, 0, 'Deposit', '2023-11-25', 5, 105, 5);

-- CreditCard Table
INSERT INTO CreditCard (CardNumber, ExpirationDate, CVV, CreditLimit, AvailableCredit, PaymentDueDate, AccountID, RequestID, HandledBY)
VALUES
(1234567890123456, '2023-12-31', 123, 5000.00, 3000.00, '2023-12-15', 101, 1, 101),
(9876543210987654, '2023-11-30', 456, 8000.00, 6000.00, '2023-11-25', 102, 2, 102),
(1111222233334444, '2023-12-15', 789, 10000.00, 8000.00, '2023-12-02', 103, 3, 103),
(5555666677778888, '2023-11-28', 321, 6000.00, 4500.00, '2023-11-30', 104, 4, 104),
(9999888877776666, '2023-12-31', 654, 9000.00, 7000.00, '2023-11-28', 105, 5, 105);

-- Loan Table
INSERT INTO Loan (LoanAmount, LoanType, LoanStatus, OutstandingBalance, PaymentAmount, PaymentFrequency, LoanTerm, InterestRate, RequestID, HandledBY, CustomerID)
VALUES
(5000.00, 'Personal Loan', 'Approved', 2000.00, 150.00, 'Monthly', 12, 8.5, 1, 101, 1),
(10000.00, 'Home Loan', 'Processing', 5000.00, 300.00, 'Monthly', 24, 7.5, 2, 102, 2),
(15000.00, 'Car Loan', 'Rejected', 0.00, 0.00, 'N/A', 0, 0.0, 3, 103, 3),
(8000.00, 'Student Loan', 'Approved', 3000.00, 200.00, 'Monthly', 36, 6.5, 4, 104, 4),
(12000.00, 'Business Loan', 'Processing', 6000.00, 400.00, 'Monthly', 48, 8.0, 5, 105, 5);

-- Tickets Table
INSERT INTO Tickets (TicketID, Category, Priority, Status, Description, DateCreated, LastUpdated, LastUpdateEmployeeID, ReservedToEmployeeID, SubmittingCustomerID)
VALUES
(1, 'Account Issue', 'High', 'Open', 'Cannot access online banking', '2023-12-05 09:30:00', '2023-12-05 09:30:00', 101, NULL, 1),
(2, 'Transaction Dispute', 'Medium', 'In Progress', 'Incorrect withdrawal amount', '2023-11-28 15:00:00', '2023-12-02 10:45:00', 102, 103, 2),
(3, 'Credit Card Inquiry', 'Low', 'Closed', 'Query about credit limit', '2023-11-30 11:20:00', '2023-11-30 11:20:00', 103, NULL, 3),
(4, 'Loan Application', 'High', 'Open', 'Status of home loan application', '2023-12-02 17:45:00', '2023-12-02 17:45:00', 104, NULL, 4),
(5, 'General Inquiry', 'Low', 'Open', 'Information about account types', '2023-11-25 10:10:00', '2023-11-28 09:15:00', 105, 101, 5);

-- Instructions Table
INSERT INTO Instructions (InstructionID, Type, Amount, Status, Recipient, Description, DateCreated, InstructorID, InstructedEmployeeID)
VALUES
(1, 'Transfer', 500.00, 'Pending', 103, 'Transfer to savings account', '2023-12-05 10:00:00', 101, 102),
(2, 'Withdrawal', 200.00, 'Pending', 104, 'ATM withdrawal', '2023-11-28 16:30:00', 102, 103),
(3, 'Deposit', 1000.00, 'Completed', 105, 'Cash deposit', '2023-11-30 12:15:00', 103, 104),
(4, 'Transfer', 300.00, 'Pending', 101, 'Transfer to checking account', '2023-12-02 18:00:00', 104, 105),
(5, 'Withdrawal', 150.00, 'Completed', 102, 'ATM withdrawal', '2023-11-25 11:30:00', 105, 101);

-- Reports Table
INSERT INTO Reports (ReportID, Category, DateGenerated, Format, File_Link, Description, SubmitterEmployeeID)
VALUES
(1, 'Financial', '2023-12-05 14:00:00', 'PDF', 'link-to-file-1', 'Monthly financial report', 101),
(2, 'Customer Service', '2023-11-28 13:45:00', 'Excel', 'link-to-file-2', 'Customer feedback summary', 102),
(3, 'Security', '2023-11-30 14:30:00', 'Word', 'link-to-file-3', 'Security incident report', 103),
(4, 'Operations', '2023-12-02 15:15:00', 'PDF', 'link-to-file-4', 'Branch operations review', 104),
(5, 'HR', '2023-11-25 13:00:00', 'Excel', 'link-to-file-5', 'Employee performance analysis', 105);

-- Attendance Table
INSERT INTO Attendance (AttendanceID, EmployeeID, Date, TimeIn, TimeOut, Status)
VALUES
(1, 101, '2023-12-05', '09:00:00', '17:00:00', 'Present'),
(2, 102, '2023-11-28', '10:00:00', '18:00:00', 'Present'),
(3, 103, '2023-11-30', '09:30:00', '17:30:00', 'Present'),
(4, 104, '2023-12-02', '08:45:00', '16:45:00', 'Present'),
(5, 105, '2023-11-25', '09:15:00', '17:15:00', 'Present');
-- Authentication Table
INSERT INTO Authentication (Username, PasswordHash, Salt, Email, Pno, AccountStatus, UserTYPE)
VALUES
('user1', 'hashed_password1', 'salt1', 'user1@example.com', 123456789, 'Active', 'Regular'),
('admin1', 'hashed_password2', 'salt2', 'admin1@example.com', 987654321, 'Active', 'Admin'),
('manager1', 'hashed_password3', 'salt3', 'manager1@example.com', 111223344, 'Active', 'Manager'),
('clerk1', 'hashed_password4', 'salt4', 'clerk1@example.com', 555566667, 'Active', 'Clerk'),
('user2', 'hashed_password5', 'salt5', 'user2@example.com', 444455556, 'Active', 'Regular');

-- Bank Table
INSERT INTO Bank (BankID, BankName, EstablishmentDate)
VALUES
(1, 'ABC Bank', '2020-01-01'),
(2, 'XYZ Bank', '2019-05-15'),
(3, '123 Bank', '2022-03-10'),
(4, '456 Bank', '2021-08-20'),
(5, '789 Bank', '2023-01-01');

-- Bank_Contact_information Table
INSERT INTO Bank_Contact_information (ContactInformation, BankID, Department)
VALUES
('123 Main St, City1', 1, 'Customer Service'),
('456 Oak St, City2', 2, 'Loan Department'),
('789 Pine St, City3', 3, 'Accounting'),
('101 Elm St, City4', 4, 'HR'),
('202 Maple St, City5', 5, 'IT');

-- Branch Table
INSERT INTO Branch (BranchID, BankID, ManagerID, BranchName, BranchAddress, OpeningDate, OperatingHours)
VALUES
(1, 1, 101, 'Main Branch', '123 Main St, City1', '2020-02-01', '9 AM - 5 PM'),
(2, 2, 102, 'Downtown Branch', '456 Oak St, City2', '2019-06-01', '8 AM - 4 PM'),
(3, 3, 103, 'North Branch', '789 Pine St, City3', '2022-04-01', '10 AM - 6 PM'),
(4, 4, 104, 'South Branch', '101 Elm St, City4', '2021-09-15', '9:30 AM - 5:30 PM'),
(5, 5, 105, 'West Branch', '202 Maple St, City5', '2023-02-15', '8:30 AM - 4:30 PM');

-- Employee Table
INSERT INTO Employee (EmployeeID, EmployeeType, Fname, Lname, Pno, Vacation_Days_remaining, Bdate, Gender, Address, SSN, Martial_State, Terminatoin_Date, Hire_Date, Working_Hours_Per_week, Salary, Email, Username, BranchID)
VALUES
(101, 'Manager', 'John', 'Doe', 111223344, 20, '1985-05-10', 'M', '123 Main St, City1', 123456789, 'Married', NULL, '2010-01-15', 40, 60000, 'john.d@example.com', 'manager1', 1),
(102, 'Clerk', 'Jane', 'Smith', 555566667, 15, '1990-08-25', 'F', '456 Oak St, City2', 987654321, 'Single', NULL, '2015-03-20', 35, 45000, 'jane.s@example.com', 'clerk1', 2),
(103, 'Regular', 'Bob', 'Johnson', 444455556, 18, '1988-11-30', 'M', '789 Pine St, City3', 111223344, 'Divorced', NULL, '2018-06-10', 38, 55000, 'bob.j@example.com', 'user1', 3),
(104, 'Regular', 'Alice', 'Williams', 666677778, 20, '1987-04-15', 'F', '101 Elm St, City4', 333344445, 'Single', NULL, '2017-09-01', 37, 50000, 'alice.w@example.com', 'user2', 4),
(105, 'Manager', 'Mike', 'Brown', 888899990, 22, '1980-12-05', 'M', '202 Maple St, City5', 222233334, 'Married', NULL, '2012-02-28', 40, 65000, 'mike.b@example.com', 'manager2', 5);

-- Customer Table
INSERT INTO Customer (CustomerID, PhoneNumber, FirstName, LastName, SSN, MaritalStatus, Occupation, DateOfBirth, Gender, Address, AnnualIncome, RegistrationDate, LastLoginDate, Email, BranchID, Username)
VALUES
(1, '1112223333', 'Sarah', 'Jones', '111223344', 'Single', 'Engineer', '1992-07-20', 'F', '123 Main St, City1', 70000, '2015-01-10', '2023-12-01', 'sarah.j@example.com', 1, 'user3'),
(2, '2223334444', 'David', 'Miller', '555666777', 'Married', 'Teacher', '1980-05-12', 'M', '456 Oak St, City2', 90000, '2019-02-22', '2023-11-30', 'david.m@example.com', 2, 'user4'),
(3, '3334445555', 'Emily', 'Davis', '999888777', 'Divorced', 'Doctor', '1975-10-05', 'F', '789 Pine St, City3', 120000, '2017-08-15', '2023-11-28', 'emily.d@example.com', 3, 'user5'),
(4, '4445556666', 'Kevin', 'Brown', '333444555', 'Single', 'Software Engineer', '1988-02-18', 'M', '101 Elm St, City4', 80000, '2016-06-30', '2023-12-02', 'kevin.b@example.com', 4, 'user6'),
(5, '5556667777', 'Hannah', 'Lee', '777888999', 'Married', 'Nurse', '1995-12-03', 'F', '202 Maple St, City5', 95000, '2020-03-10', '2023-11-25', 'hannah.l@example.com', 5, 'user7');
