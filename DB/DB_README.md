---
author: dawidh15
why: Helpers to setup database stuff.
---

# MySQL

Do not confuse *MySQL Shell* with executables like `mysql.exe`. The have different functions and paths in Environment Vars.

## Install MySQL Script

TODO

## Environment path script

TODO

## Useful admin commands

Set up a never expire password:

```sql
MySQL> ALTER USER `root`@`host` IDENTIFIED BY '<newPassword>', `root`@`host` PASSWORD EXPIRE NEVER;
```

## Connect to server using interactive mysql Shell

```sql
mysqlsh> \connect <user>@<host>
mysqlsh 'please provide password for  <user>@<host>'> ********
```

## Store a password on .mylogin.cnf

Using a shell like powershell, if mysql server bin is in the path, follow this steps:

```sql
shell> mysql_config_editor set --login-path=client
         --host=localhost --user=localuser --password
Enter password: enter password "localpass" here
shell> mysql_config_editor set --login-path=remote
         --host=remote.example.com --user=remoteuser --password
Enter password: enter password "remotepass" here
```

After saving the password, a connection without specifying user or password would be directed to the user stored in the `.mylogin.cnf`.

```sql
shell> mysql --host=localhost
mysql> select user();
+--------------------+
| user()             |
+--------------------+
| localuser@localhost |
+--------------------+
1 row in set (0.00 sec)
```

## MySQL from powerShell

https://www.databasejournal.com/features/mysql/running-commands-against-your-mysql-databases-using-powershell.html

https://www.databasejournal.com/features/mysql/automate-mysql-queries-with-powershell.html
