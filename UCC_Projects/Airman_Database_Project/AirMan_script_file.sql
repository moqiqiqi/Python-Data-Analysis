-- Create a new database named AirMan
drop database AirMan;
CREATE database AirMan;

-- Select the AirMan database for use
Use AirMan;


CREATE TABLE IF NOT EXISTS customers (
customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
name VARCHAR(20) NOT NULL DEFAULT '',
address VARCHAR(20) NOT NULL DEFAULT '',
phone_number INT UNSIGNED,
email VARCHAR(20) NOT NULL DEFAULT '',
type VARCHAR(20) NOT NULL DEFAULT '',
social_insurance_number INT UNSIGNED NOT NULL DEFAULT 0,

PRIMARY KEY (customer_id)
);


CREATE TABLE IF NOT EXISTS aircrafts (
aircraft_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
registration_number VARCHAR(20) NOT NULL DEFAULT '',
type VARCHAR(20) NOT NULL DEFAULT '',
size VARCHAR(20) NOT NULL DEFAULT '',
model_number VARCHAR(30) NOT NULL DEFAULT '',
capacity  VARCHAR(20) NOT NULL DEFAULT '',

PRIMARY KEY (aircraft_id)
);

--  Part1: buy 

CREATE TABLE IF NOT EXISTS purchases (
purchase_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
purchase_date DATE,
cost_pound DECIMAL(12,2) NOT NULL DEFAULT 0.00,

customer_id INT UNSIGNED,
aircraft_id INT UNSIGNED,

PRIMARY KEY (purchase_id),
FOREIGN KEY (customer_id) REFERENCES  customers (customer_id),
FOREIGN KEY (aircraft_id) REFERENCES aircrafts (aircraft_id) 
);


-- Create an employees table
CREATE TABLE IF NOT EXISTS ownerships (
ownership_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
start_date DATE,
end_date DATE,

PRIMARY KEY (ownership_id),
purchase_id INT UNSIGNED,
FOREIGN KEY (purchase_id) REFERENCES purchases (purchase_id) 
);

--  Part2: leases 

CREATE TABLE IF NOT EXISTS leases (
lease_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
lease_date DATE,
cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
duration INT,

customer_id INT UNSIGNED,
aircraft_id INT UNSIGNED,

PRIMARY KEY (lease_id),
FOREIGN KEY (customer_id) REFERENCES  customers (customer_id),
FOREIGN KEY (aircraft_id) REFERENCES aircrafts (aircraft_id) 
); 

--  Part3: team

CREATE TABLE IF NOT EXISTS employee_teams (
team_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
type VARCHAR(20) NOT NULL DEFAULT '',
maintenance_skillsets VARCHAR(20), --  NOT NULL DEFAULT ''


supervisor_id INT UNSIGNED,

PRIMARY KEY (team_id)
);



CREATE TABLE IF NOT EXISTS shifts (
shift_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
shift_name VARCHAR(20) NOT NULL DEFAULT '',
start_datetime DATETIME,
end_datetime DATETIME,
break_datetime DATETIME,

remarks VARCHAR(200) NOT NULL DEFAULT '',

team_id INT UNSIGNED,

PRIMARY KEY (shift_id),
FOREIGN KEY (team_id) REFERENCES  employee_teams (team_id)
);


CREATE TABLE IF NOT EXISTS employees (
employee_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
name VARCHAR(20) NOT NULL DEFAULT '',
address VARCHAR(40) NOT NULL DEFAULT '',
phone_number VARCHAR(10), 
email VARCHAR(30) NOT NULL DEFAULT '',
-- type VARCHAR(20) NOT NULL DEFAULT '',
social_insurance_number INT UNSIGNED NOT NULL DEFAULT 0,
salary DECIMAL(8,2) NOT NULL DEFAULT 0.00,
job_level VARCHAR(20) NOT NULL DEFAULT '',

PRIMARY KEY (employee_id),
team_id INT UNSIGNED, -- team id can indicate employee type

FOREIGN KEY (team_id) REFERENCES employee_teams (team_id) 
);

ALTER TABLE employee_teams 
	ADD FOREIGN KEY (supervisor_id) REFERENCES employees(employee_ID);

--  Part4: books 

CREATE TABLE IF NOT EXISTS books (
book_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
type VARCHAR(20) NOT NULL DEFAULT '',
book_date DATE,
aircraft_id INT UNSIGNED,
customer_id INT UNSIGNED,
team_id INT UNSIGNED,

PRIMARY KEY (book_id),
FOREIGN KEY (customer_id) REFERENCES  customers (customer_id),
FOREIGN KEY (aircraft_id) REFERENCES aircrafts (aircraft_id) ,
FOREIGN KEY (team_id) REFERENCES employee_teams (team_id) 
);


--  Part5: clean 

CREATE TABLE IF NOT EXISTS contracts (
contract_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
effective_date DATE,
expiration_date DATE,

customer_id INT UNSIGNED,

PRIMARY KEY (contract_id),
FOREIGN KEY (customer_id) REFERENCES  customers (customer_id)
);

CREATE TABLE IF NOT EXISTS cleanings (
cleaning_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
cleaning_datetime DATETIME,
cost_per_hour DECIMAL(6,2) NOT NULL DEFAULT 0.00,
hours_spent INT UNSIGNED NOT NULL DEFAULT 0,


contract_id INT UNSIGNED,
book_id INT UNSIGNED,

PRIMARY KEY (cleaning_id),
FOREIGN KEY (contract_id) REFERENCES contracts (contract_id),
FOREIGN KEY (book_id) REFERENCES books (book_id)
);


-- Assuming that the parking date is the number of days of parking.
--  Part6: parking

CREATE TABLE IF NOT EXISTS parkings (
parking_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
arrival_datetime DATETIME,
location VARCHAR(20) NOT NULL DEFAULT '', 
parking_date DATE, 
unit_landing_fee DECIMAL(8,2) NOT NULL DEFAULT 0.00,
parking_fee DECIMAL(8,2) NOT NULL DEFAULT 0.00,
departure_datetime DATETIME, 
basis_type VARCHAR(20) NOT NULL DEFAULT '', 

book_id INT UNSIGNED,

PRIMARY KEY (parking_id),
FOREIGN KEY (book_id) REFERENCES books (book_id)
);


--  Part7: fuellings
CREATE TABLE IF NOT EXISTS fuellings (
fuelling_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
fuelling_datetime DATETIME, 
barrel_amount INT UNSIGNED NOT NULL DEFAULT 0,
service_fee DECIMAL(8,2) NOT NULL DEFAULT 0.00,
price_per_barrel DECIMAL(8,2) NOT NULL DEFAULT 0.00,

book_id INT UNSIGNED,

PRIMARY KEY (fuelling_id),
FOREIGN KEY (book_id) REFERENCES books (book_id)
);


-- Part8 : maintenance_services
CREATE TABLE IF NOT EXISTS maintenance_services (
service_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
service_datetime DATETIME, 
hours_spent INT UNSIGNED NOT NULL DEFAULT 0,
type VARCHAR(30) NOT NULL DEFAULT '',
cost_per_hour DECIMAL(6,2) NOT NULL DEFAULT 0.00, -- Assuming there is the cost per hour ：this takes a service team of three an hour to deep maitenance a large business jet(£500.) small (£200) , mid-size(£300). Cost per jet £500.

book_id INT UNSIGNED,

PRIMARY KEY (service_id ),
FOREIGN KEY (book_id) REFERENCES books (book_id)
);


-- Part9 : storages
-- Since Storage times are usually longer than one month, use 'int' as the data type.

CREATE TABLE IF NOT EXISTS storages (
storage_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
location VARCHAR(20) NOT NULL DEFAULT '',  
arrival_datetime DATETIME,  
storage_date INT UNSIGNED NOT NULL DEFAULT 0,  
departure_datetime DATETIME, 
unit_landing_fee DECIMAL(8,2) NOT NULL DEFAULT 0.00,
hanger_fee DECIMAL(8,2) DEFAULT 0.00,
annual_fee DECIMAL(8,2) NOT NULL DEFAULT 0.00,

book_id INT UNSIGNED,

PRIMARY KEY (storage_id),
FOREIGN KEY (book_id) REFERENCES books (book_id)
);


--  Part10: pilots
CREATE TABLE IF NOT EXISTS pilots (
pilot_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
name VARCHAR(20) NOT NULL DEFAULT '',
address VARCHAR(20) NOT NULL DEFAULT '',
phone_number INT UNSIGNED, 
email VARCHAR(20) NOT NULL DEFAULT '',
social_insurance_number INT UNSIGNED NOT NULL DEFAULT 0,
license_number INT UNSIGNED NOT NULL DEFAULT 0, 
operational_status VARCHAR(20) NOT NULL DEFAULT '', 
aircraft_type VARCHAR(20) NOT NULL DEFAULT '',  

PRIMARY KEY (pilot_id)
);

CREATE TABLE pilot_aircraft_assignments (
    aircraft_id INT UNSIGNED,
    pilot_id INT UNSIGNED,
    PRIMARY KEY (aircraft_id, pilot_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id),
    FOREIGN KEY (pilot_id) REFERENCES pilots(pilot_id)
);


INSERT INTO customers (name, address, phone_number, email, type, social_insurance_number) 
VALUES 
('John Doe', '123 Maple St', 878870439, 'johndoe@gmail.com', 'aircraft owner', 123100001),
('Jane Smith', '456 Oak Rd', 874873390, 'janesmith@gmail.com', 'pilot', 123100002),
('Alex Johnson', '789 Pine Ave', 874732310, 'alexj@gmail.com', 'pilot', 123100003),
('Mary King', '188 Park St', 899643571, 'mary.K@gmail.com', 'aircraft owner', 123100004),
('Lucy Chen', '446 SouthMain Rd', 999124763, 'lucyC@gmail.com', 'corporation', 123100005);

-- Alex Johnson and Jane Smith are both customer and pilots


INSERT INTO aircrafts (size,type,model_number,registration_number, capacity) VALUES
('Medium',' Jet', 'Hawker 850XP', 'XA-DON', 8),
('Large ','Jet', 'Legacy 650', 'G-WIRG', 14),
('small ','Jet', 'Falcon 50EX', 'N180NL', 7),
('small ','helicopter', 'Airbus Helicopters H125', 'H125', 7),
('small ','propeller', 'Cessna 172 Skyhawk', '172 Skyhawk', 4);

INSERT INTO purchases (purchase_date, cost_pound, customer_id, aircraft_id) VALUES
('2022-10-21', 1085000000.00, 1, 1),
('2021-06-30', 4352040.00, 2, 3),
('2021-06-21', 2336000000.00, 5, 2);


INSERT INTO ownerships (start_date, end_date, purchase_id) VALUES
('2022-10-21', '2024-12-31', 1),
('2021-06-30', '2024-06-30', 2),
('2021-06-21', '2024-06-21', 3);


INSERT INTO leases (lease_date, cost, duration, customer_id, aircraft_id) VALUES
('2024-01-15', 1500000.00, 12, 3, 4),
('2024-01-20', 80000.00, 6, 4, 5);


INSERT INTO employees (name, address, phone_number, email, social_insurance_number, salary, job_level) VALUES
('John Smith', '123 Main Street', 1234567890, 'john@example.com', 123456789, 30000.00, 'Regular'),
('Alice Johnson', '456 Elm Street', 9876543210, 'alice@example.com', 987654321, 30000.00, 'Regular'),
('Michael Davis', '789 Oak Street', 5558889999, 'michael@example.com', 555555555, 35000.00, 'Supervisor'),
('Emily Brown', '321 Pine Street', 1112223333, 'emily@example.com', 111111111, 30000.00, 'Regular'),
('James Wilson', '654 Maple Street', 4445556666, 'james@example.com', 222222222, 30000.00, 'Regular'),
('Sophia Lee', '987 Cedar Street', 7778889999, 'sophia@example.com', 777777777, 35000.00, 'Supervisor'),
('Daniel Taylor', '135 Walnut Street', 8887776666, 'daniel@example.com', 333333333, 40000.00, 'Regular'),
('Olivia Martinez', '246 Birch Street', 2223334444, 'olivia@example.com', 444444444, 40000.00, 'Regular'),
('William Garcia', '579 Pineapple Street', 9998887777, 'william@example.com', 999999999, 45000.00, 'Supervisor'),
('Emma Rodriguez', '753 Cherry Street', 6665554444, 'emma@example.com', 555555555, 55000.00, 'Regular'),
('Liam Wilson', '864 Grape Street', 3334445555, 'liam@example.com', 666666666, 55000.00, 'Regular'),
('Ava Smith', '975 Mango Street', 2223334444, 'ava@example.com', 111222333, 65000.00, 'Supervisor'),
('Noah Johnson', '147 Orange Street', 7778889999, 'noah@example.com', 777777777, 50000.00, 'Regular'),
('Charlotte Brown', '258 Lemon Street', 8889990000, 'charlotte@example.com', 888888888, 50000.00, 'Regular'),
('Sophia Wilson', '369 Watermelon Street', 1112223333, 'sophia@example.com', 333444555, 65000.00, 'Supervisor'),
('Jessica Miller', '789 Pine Street', 5551234567, 'jessica@example.com', 555123456, 70000.00, 'Manager');


INSERT INTO employee_teams (type, maintenance_skillsets, supervisor_id) VALUES
('cleaning', null, 3),
('ground handling', null, 6), 
('service-maintenance', 'Jet', 9), 
('service-maintenance', 'helicopter',12),
('Service-Maintenance', 'propeller', 15);

UPDATE employees
SET team_id = CASE
    WHEN employee_id BETWEEN 1 AND 3 THEN 1
    WHEN employee_id BETWEEN 4 AND 6 THEN 2
    WHEN employee_id BETWEEN 7 AND 9 THEN 3
    WHEN employee_id BETWEEN 10 AND 12 THEN 4
    WHEN employee_id BETWEEN 13 AND 15 THEN 5
    ELSE team_id
END
WHERE employee_id BETWEEN 1 AND 15; 



INSERT INTO shifts (shift_name, start_datetime, end_datetime, break_datetime, remarks, team_id) VALUES
('Morning Shift', '2024-02-10 08:00:00', '2024-02-10 16:00:00', '2024-02-10 12:00:00', 'regular cleaning tasks', 1),
('Afternoon Shift', '2024-02-12 12:00:00', '2024-02-12 20:00:00', '2024-02-12 16:00:00', 'baggage handling', 2),
('Night Shift', '2024-02-15 20:00:00', '2024-02-15 04:00:00', null, 'emergency repairs', 3),
('Day Shift', '2024-02-20 08:00:00', '2024-02-20 16:00:00', '2024-02-20 12:00:00', 'routine inspections', 4),
('Evening Shift', '2024-02-28 16:00:00', '2024-02-28 00:00:00', '2024-02-28 20:00:00', 'avionics system troubleshooting and repair', 5);


INSERT INTO books (type, book_date, aircraft_id, customer_id, team_id) VALUES  
('cleaning', '2024-02-08', 1, 1, 1),
('cleaning', '2024-02-12', 2, 5, 1),
('fuelling', '2024-02-12', 2, 5, 2),
('fuelling', '2024-02-19', 3, 2, 2),
('maintenance', '2024-02-20', 3, 2, 3),
('maintenance', '2024-01-01', 4, 4, 3),
('storage', '2024-02-01', 4, 4,2),
('parking', '2024-02-20', 3, 2,2),
('parking', '2024-02-28', 5 ,3,2);


INSERT INTO contracts (effective_date, expiration_date, customer_id) VALUES  
('2024-01-01', '2024-12-31', 1),
('2024-01-01', '2024-06-30', 5);


-- It takes a service team of three an hour to deep clean a mid-sized business jet. Cost per jet £500. 
-- Assuming a large-size one takes two hours，namyly, cost per jet £1000.
INSERT INTO cleanings (cleaning_datetime, cost_per_hour,hours_spent, contract_id, book_id) VALUES  
('2024-02-08 10:00:00', 500.00,1, 1, 1),  
('2024-02-12 16:00:00', 500.00,2, 2, 2);

-- price US gallons 109.08 dollar/bbl
-- amount unit: gallon
-- 
-- amount 60bbl*42 gallon/bbl= 2520 gallon
-- 30*42=1260
-- 1dollar = 0.7915pound



INSERT INTO fuellings (fuelling_datetime, barrel_amount,service_fee, price_per_barrel, book_id)
VALUES 
('2024-02-10 09:00:00', 60,500,109.08, 3),
('2024-02-15 10:00:00', 30,200,109.08, 4);



INSERT INTO maintenance_services (service_datetime, hours_spent,cost_per_hour, type, book_id)
VALUES 
('2024-02-11 08:00:00', 5, 200, 'Jet Routine Check', 5),
('2024-02-16 10:00:00', 8, 200, 'Helicopter Engine Maintenance', 6);


INSERT INTO parkings (arrival_datetime, location, parking_date, unit_landing_fee, parking_fee, departure_datetime, basis_type, book_id)
VALUES 
('2024-02-10 10:00:00', 'A1', '2024-02-20', 300.00, 150, '2024-02-22 12:00:00', 'resident', 8),
('2024-02-15 08:00:00', 'A2', '2024-02-27', 300.00, 300, '2024-02-28 18:00:00', 'visiting', 9);

-- storage_date (int) indicates days.


-- Assuming an annual membership is available, H125小飞机,unit_landing_fee =150
INSERT INTO storages (location, arrival_datetime, storage_date, departure_datetime,unit_landing_fee,hanger_fee,annual_fee, book_id)
VALUES 
('E1', '2024-03-01 08:00:00', 61,'2024-05-01 08:00:00', 150,5000,50000 ,7);




-- Alex Johnson and Jane Smith are both customer and pilots
INSERT INTO pilots (name, address, phone_number, email, social_insurance_number, license_number, operational_status, aircraft_type)
VALUES 
('Tom Williams', '123 Elm St', 1234567890, 'tom@example.com', 123456789, 987654321, 'Active', 'Jet'),
('Sarah Johnson', '456 Oak St', 1876543210, 'sarah@example.com', 987654321, 123456789, 'Active', 'Propeller'),
('Alex Johnson', '789 Pine Ave', 874732310, 'alexj@gmail.com', 123100003, 654321987, 'Active', 'Jet'),
('Jane Smith', '456 Oak Rd', 874873390, 'janesmith@gmail.com', 123100002, 126996780, 'Active','Propeller');

INSERT INTO pilot_aircraft_assignments (aircraft_id, pilot_id)
VALUES 
(1, 3),
(2, 4);






