# OnBank
## Online Banking Application

### Database Design
#### Entity Relationship Diagram
![alt text](https://raw.githubusercontent.com/Dokany/OnBank/master/Documentation/ERD.png?token=ALCu3DH-8Gs7xCZNB7wyEkXfmvQ6WtwFks5bRhtwwA%3D%3D "ER Diagram")

### Entity-to-Relational Diagram
![alt text](https://raw.githubusercontent.com/Dokany/OnBank/master/Documentation/Relational.png?token=ALCu3FK-c1XsKvCAN9noGtmBM2CjPT8Nks5bRhuXwA%3D%3D "Relational Diagram")

### Events
- Adding Daily Interest Transactions
One of the project requirements was adding interest transactions to account balances daily, so a simple daily event with a join between the **account** and **account_type** tables made the trick as shown:
~~~ mysql
CREATE EVENT daily_interest
	ON SCHEDULE
    	EVERY 1 DAY STARTS '2018-07-01 12:30:00'
	COMMENT 'Daily Interest Transaction on Accounts'
    DO 
    	UPDATE account a, account_type t SET a.Balance = a.Balance * (1 + t.InterestRate/100) WHERE a.AcctType = t.AcctType;
~~~
