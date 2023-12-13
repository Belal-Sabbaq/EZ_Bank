
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
);

CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    BankID INT,
    ManagerID INT,
    BranchName VARCHAR(50) UNIQUE NOT NULL,
    BranchAddress VARCHAR(255) UNIQUE NOT NULL,
    OpeningDate DATE NOT NULL,
    OperatingHours VARCHAR(50) NOT NULL
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
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (Username) REFERENCES Authentication(Username)
);
ALTER TABLE Branch
ADD CONSTRAINT FK_Branch_Manager FOREIGN KEY (ManagerID) REFERENCES Employee(EmployeeID);

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
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (Username) REFERENCES Authentication(Username)
);

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
    ActionByID INT NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (BankID) REFERENCES Bank(BANKID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ActionByID) REFERENCES Employee(EmployeeID)
);


CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    Fees DECIMAL(18, 2) NOT NULL,
    ReferenceNumbners INT NOT NULL Unique,
    TransactionDate DATETIME NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    Status VARCHAR(50) NOT NUll DEFAULT 'Proccessing',
    Type VARCHAR(10) NOT NULL,
    Currency Varchar(20) NOT NULL DEFAULT 'EGP',
    SendingAccount INT,
    ReceivingAccount INT,
    FOREIGN KEY (SendingAccount) REFERENCES Account(AccountID),
    FOREIGN KEY (ReceivingAccount) REFERENCES Account(AccountID)
);


CREATE TABLE DebitCard (
    CardNumber INT PRIMARY KEY,
    ExpirationDate DATE,
    CVV INT,
    TransactionLimit DECIMAL(18, 2),
    RequestID INT Unique NOT NULL,
    HandledBY INT NOT NULL DEFAULT NULL,
    AccountID INT,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    Foreign key (HandledBY) REFERENCES Employee(EmployeeID)
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
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
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
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
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
    FOREIGN KEY (Recipient) REFERENCES Account(AccountID),
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
