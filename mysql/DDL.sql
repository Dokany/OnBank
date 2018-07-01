-- SQL Schema for Online Banking Application

CREATE TABLE administrator (
    AdminID    SMALLINT UNSIGNED ZEROFILL AUTO_INCREMENT,
    AUsername  VARCHAR(15) NOT NULL,
    APassword  BINARY(60) NOT NULL,
    ALastLogin TIMESTAMP,
    CONSTRAINT administrator_AdminID_pk PRIMARY KEY(AdminID)
);

CREATE TABLE teller (
    TellerID   SMALLINT UNSIGNED ZEROFILL AUTO_INCREMENT,
    TUsername  VARCHAR(15) NOT NULL,
    TPassword  BINARY(60) NOT NULL,
    TLastLogin TIMESTAMP,
    CONSTRAINT teller_TellerID_pk PRIMARY KEY(TellerID)
);

CREATE TABLE client (
    ClientID   SMALLINT UNSIGNED ZEROFILL AUTO_INCREMENT,
    NIN        CHAR(14) NOT NULL UNIQUE,
    Fname      VARCHAR(15) NOT NULL,
    Lname      VARCHAR(15) NOT NULL,
    CUsername  VARCHAR(15) NOT NULL,
    CPassword  BINARY(60) NOT NULL,
    BDate      DATE,
    Address    VARCHAR(20),
    PhoneNo    INT(9) UNSIGNED,
    Email      VARCHAR(50),
    AdminID    SMALLINT UNSIGNED,
    CLastLogin TIMESTAMP,
    CONSTRAINT client_ClientID_pk PRIMARY KEY(ClientID)
);

CREATE TABLE transaction (
    TransactionNo SMALLINT UNSIGNED ZEROFILL AUTO_INCREMENT,
    TDate    DATE NOT NULL,
    Amount   DECIMAL(14,4) NOT NULL,
    TellerID SMALLINT UNSIGNED,
    ClientID SMALLINT UNSIGNED,
    AcctNo   SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT transaction_TransactionNo_pk PRIMARY KEY(TransactionNo)
);

CREATE TABLE account (
    AcctNo   SMALLINT UNSIGNED ZEROFILL AUTO_INCREMENT,
    Balance  DECIMAL(14,4) NOT NULL,
    AcctType CHAR NOT NULL,
    Abbreviation CHAR(3) NOT NULL,
    NIN      CHAR(14) NOT NULL,
    ClientID SMALLINT UNSIGNED,
    CONSTRAINT account_AcctNo_pk PRIMARY KEY(AcctNo)
);

CREATE TABLE owner_info (
    NIN        CHAR(14),
    Fname      VARCHAR(15) NOT NULL,
    Lname      VARCHAR(15) NOT NULL,
    CONSTRAINT owner_info_NIN_pk PRIMARY KEY(NIN)
);

CREATE TABLE currency (
    Abbreviation CHAR(3),
    CONSTRAINT currency_Abbreviation_pk PRIMARY KEY(Abbreviation)
);

CREATE TABLE currency_exchange (
    CurrentAbbr  CHAR(3),
    NewAbbr      CHAR(3),
    ExchangeRate DECIMAL(6,4),
    CONSTRAINT currency_exchange_CurrentAbbr_NewAbbr_pk PRIMARY KEY(CurrentAbbr, NewAbbr)
);

CREATE TABLE account_type (
    AcctType CHAR,
    InterestRate DECIMAL(5,4),
    CONSTRAINT account_type_AcctType_pk PRIMARY KEY(AcctType)
);

-- FOREIGN KEYS
ALTER TABLE client ADD CONSTRAINT client_AdminID_fk FOREIGN KEY (AdminID) REFERENCES administrator(AdminID);

ALTER TABLE transaction ADD CONSTRAINT transaction_TellerID_fk FOREIGN KEY (TellerID) REFERENCES teller(TellerID);
ALTER TABLE transaction ADD CONSTRAINT transaction_ClientID_fk FOREIGN KEY (ClientID) REFERENCES client(ClientID);
ALTER TABLE transaction ADD CONSTRAINT transaction_AcctNo_fk FOREIGN KEY (AcctNo) REFERENCES account(AcctNo);

ALTER TABLE account ADD CONSTRAINT account_AcctType_fk FOREIGN KEY (AcctType) REFERENCES account_type(AcctType);
ALTER TABLE account ADD CONSTRAINT account_Abbreviation_fk FOREIGN KEY (Abbreviation) REFERENCES currency(Abbreviation);
ALTER TABLE account ADD CONSTRAINT account_NIN_fk FOREIGN KEY (NIN) REFERENCES owner_info(NIN);
ALTER TABLE account ADD CONSTRAINT account_ClientID_fk FOREIGN KEY (ClientID) REFERENCES client(ClientID);

ALTER TABLE currency_exchange ADD CONSTRAINT currency_exchange_CurrentAbbr_fk FOREIGN KEY (CurrentAbbr) REFERENCES currency(Abbreviation);
ALTER TABLE currency_exchange ADD CONSTRAINT currency_exchange_NewAbbr_fk FOREIGN KEY (NewAbbr) REFERENCES currency(Abbreviation);