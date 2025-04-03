#!/bin/bash


# 1. DB automated creation
# mainly just building on the previous commands
echo "Pulling postgres: \n"
docker pull postgres


# ask for credentials, needed for all the commands
read -p "Container name: \n" container_name
read -p "User name: \n" user_name
read -p "Password: \n" password
read -p "Database name: \n" db_name

#create the container and environment variables with said credentials
docker run --name $container_name -e POSTGRES_USER=$user_name -e POSTGRES_PASSWORD=$password -e POSTGRES_DB=$db_name -d postgres

sleep 5 # wait for the container to start

# file path and file name for copying the fsql file and populating the db
echo "Provide path and sql file name: \n"
read -p "Path: \n" file_path
read -p "File name: \n" file_name

# copy the file to container
docker cp $file_path/$file_name $container_name:/$file_name

# populate the container db with the copied sql file
echo "Initializing container databse: \n"
docker exec -it $container_name psql -U $user_name -d $db_name -f /$file_name


# 2. create second admin user 

echo "Creating admin admin_cee \n"
read -p "Admin password: \n" password

#https://www.postgresql.org/docs/current/sql-createrole.html
#https://learn.microsoft.com/en-us/answers/questions/1480179/query-to-give-all-permissions-to-a-user-on-a-postg
# just by creating a role limits the admin, so we give him all permissions
# for the db
docker exec -it $container_name psql -U admin_cee -d $db_name -c "CREATE ROLE admin_cee WITH PASSWORD $adminpassword; GRANT ALL PRIVILEGES ON DATABASE $db_name TO admin_cee;"


# 3. import the created dump sql file 

echo "Provide SQL dump file for restoration: \n"

read -p "File path: " sql_file_dump_path 

# then we restore the db content
# https://davejansen.com/how-to-dump-and-restore-a-postgresql-database-from-a-docker-container/
docker exec -i $container_name /bin/bash -c "PGPASSWORD=pg_password psql --username pg_username $db_name" < $sql_file_dump_path


# 4. execute queries

# 1st query with docker exec
echo "Employees count: \n" > query_results.txt
docker exec -it postgres_container psql -U ituser -d company_db -c "SELECT COUNT(*) FROM employees;" >> query_results.txt



# 2nd query needs to call the bash script through whihc the user inputs the
# desired department
# we should run "chmod +x query2.sh" to be sure it is executable
# https://www.baeldung.com/linux/shell-call-script-from-another
echo "\n Query for department name: \n" >> query_results.txt
bash query2.sh >> query_results.txt



# 3rd query with docker exec
echo "\nMin and Max salaries per department: \n" >> query_results.txt
docker exec -it postgres_container psql -U ituser -d company_db -c " SELECT d.department_name, MIN(s.salary) AS min_salary, MAX(s.salary) AS max_salary FROM employees e JOIN departments d ON e.department_id = d.department_id JOIN salaries s ON e.employee_id = s.employee_id GROUP BY d.department_name;" >> query_results.txt













