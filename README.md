# Online Banking Application
## Application Development Process
### Diagrams
![alt text](https://raw.githubusercontent.com/Dokany/OnBank/master/Documentation/ERD.png?token=ALCu3DH-8Gs7xCZNB7wyEkXfmvQ6WtwFks5bRhtwwA%3D%3D "ER Diagram")

![alt text](https://raw.githubusercontent.com/Dokany/OnBank/master/Documentation/Relational.png?token=ALCu3FK-c1XsKvCAN9noGtmBM2CjPT8Nks5bRhuXwA%3D%3D "Relational Diagram")

### Building Backend Application
We used MAMP v4.5, configured to run MySQL v5.6.38 and PHP7.2.1, to build our application's backend.

#### Data Definition Language Schema
We formulated our databse schema's relations, columns and constraints, and imported the **[file](https://github.com/Dokany/OnBank/blob/master/src/mysql/DDL.sql)** into our database.

#### Data Insertion
We used [Fill Database](http://filldb.info/) to generate initial dummy data to start testing our database relations, then imported the **[file](https://github.com/Dokany/OnBank/blob/master/src/mysql/BankData.sql)** into our database.

#### Handling Events
- Adding Daily Interest Transactions
One of the project requirements was adding interest transactions to account balances daily, so a simple daily event with a join between the *account* and *account_type* tables made the trick as shown:
~~~ mysql
CREATE EVENT daily_interest
	ON SCHEDULE
    	EVERY 1 DAY STARTS '2018-07-01 12:30:00'
	COMMENT 'Daily Interest Transaction on Accounts'
    DO 
    	UPDATE account a, account_type t SET a.Balance = a.Balance * (1 + t.InterestRate/100) WHERE a.AcctType = t.AcctType;
~~~

### Building Frontend Application
We used Xcode v9.4.1 to develop our iOS 11 application to cater for three different types of users: clients, tellers and administrators.


## Demo
