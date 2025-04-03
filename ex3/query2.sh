#!/bin/bash

read -p "Department name: " department

docker exec -i postgres_container psql -U ituser -d company_db -c "SELECT e.first_name, e.last_name FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE d.department_name = '$department';" 

