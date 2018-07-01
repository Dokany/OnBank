# OnBank
## Online Banking Application

### Database Design
#### Entity Relationship Diagram
![alt text]("https://raw.githubusercontent.com/Dokany/OnBank/master/Documentation/ER%20Diagram.png" "ER Diagram")

### Entity-to-Relational Diagram
![alt text]("https://raw.githubusercontent.com/Dokany/OnBank/master/Documentation/ER-To-Relational%20Mapping.png" "ER Diagram")

### Events
- Adding Daily Interest Transactions
One of the project requirements was adding interest transactions to account balances daily, so a simple daily event with a join between the **account** and **account_type** tables made the trick as shown:
~~~ mysql
CREATE EVENT `daily_interest`
	ON SCHEDULE
    	EVERY 1 DAY STARTS ''
	COMMENT 'Daily Interest Transaction on Accounts'
    DO 
    	UPDATE account a, account_type t SET a.Balance = a.Balance * (1 + t.InterestRate/100) WHERE a.AcctType = t.AcctType;
~~~
