# Exercise 3




### Pull and run a PostgreSQL container.
<img src="https://github.com/HVTom/tremend_devops/blob/main/ex3/ex3_pics/docker_postgres_commands.png" width="auto" height="auto" alt="Docker Postgres Commands">


## Create a database called "company_db". 
## Do not use the default user, instead use one called "ituser".
<img src="https://github.com/HVTom/tremend_devops/blob/main/ex3/ex3_pics/postgres_container_proof.png" width="auto" height="auto" alt="Postgres Container Proof">
<img src="https://github.com/HVTom/tremend_devops/blob/main/ex3/ex3_pics/docker_desktop_postgres_credentials.png" width="auto" height="auto" alt="Docker Desktop Postgres Credentials">


(https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/) 

(https://www.baeldung.com/ops/postgresql-docker-setup)

(https://medium.com/@nathaliafriederichs/setting-up-a-postgresql-environment-in-docker-a-step-by-step-guide-55cbcb1061ba)

 - to create a containerized PostgreSQL i first ran the command "docker pull postgres" 

 - then, before i create and run the container, i set the contsiner name, user name, password and db name; all these credentials are set as environment variables with the -e flag; -d too run it in the background

 - docker run --name postgres_container -e POSTGRES_USER=ituser -e POSTGRES_PASSWORD=itpassword -e POSTGRES_DB=company_db -d postgres



# Create a dataset using the sql script provided in the folder 3-db/


copying the populatedb.sql into the container:

 - docker cp /home/toma/Desktop/tremend_devops/ex3/populatedb.sql postgres_container:/populatedb.sql
run the script to initialize the db: docker exec -it postgres_container psql -U ituser -d company_db -f /populatedb.sql

# Run the following SQL queries:

## Find the total number of employees.

 - docker exec -it postgres_container psql -U ituser -d company_db -c "SELECT COUNT(*) FROM employees;"

## Retrieve the names of employees in a specific department (prompt for userinput).

 - (https://www.linuxscrew.com/bash-prompt-for-input)
 - (https://www.sqlshack.com/learn-sql-join-multiple-tables/)
 - to take user input, a bash script could be a simple way to take user input, and use string interpolation at the end; here we just need to join the tables using the department_id columns, and condition the selection based on input department value: 

#!/bin/bash

read -p "Department name: " department

docker exec -i postgres_container psql -U ituser -d company_db -c "SELECT e.first_name, e.last_name FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE d.department_name = '$department';"

## Calculate the highest and lowest salaries per department.

so, we definitely have to join departmets, employees, and salaries, because we need the departments and salaries, and these tables are not related; so employees is the table that bridges the needed information
everytime we have to count something "per column" (department here), we clearly can write it by coupling GROUP BY and HAVING; the simplest way I could do this is by linking/chaining all the tables by having the employees as the middle table; 
docker exec -it postgres_container psql -U ituser -d company_db -c " SELECT d.department_name, MIN(s.salary) AS min_salary, MAX(s.salary) AS max_salary FROM employees e JOIN departments d ON e.department_id = d.department_id JOIN salaries s ON e.employee_id = s.employee_id GROUP BY d.department_name;"

Challenges: 
 - remembering how to write complex queries (third query)
 - remembering how to take input through bash script


# Dump the dataset into a file.
<img src="https://github.com/HVTom/tremend_devops/blob/main/ex3/ex3_pics/dump.png" width="auto" height="auto" alt="Dump">


 - (https://davejansen.com/how-to-dump-and-restore-a-postgresql-database-from-a-docker-container/)
we could use the command "

docker exec -i pg_container_name /bin/bash -c "PGPASSWORD=pg_password pg_dump --username pg_username database_name" > /desired/path/on/your/machine/dump.sql", so here i'll have "docker exec -i postgres_container /bin/bash -c "PGPASSWORD=itpassword pg_dump --username ituser company_db" > /home/toma/Desktop/tremend_devops/ex3/dump.sql"

# Write a Bash script that:

## Automates the database creation process.

 - based on what I've written in the previous exercises, taking the commands and dumping them into a bash file could initially be a starting point to having just a siingle runnable file, with all the commands one after another (all the comments and explanations are written inside the bash script)
## Creates a second admin user called "admin_cee"
## Imports the dataset created at Step 4.
## Executes the queries from Step 3 and outputs the results to a log file.
