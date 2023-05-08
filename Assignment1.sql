--create the database
create database Manufacturer;
-- create the tables
CREATE TABLE Product (
    prod_id INT NOT NULL,
    prod_name VARCHAR(50) NOT NULL,
    quantity INT,
	PRIMARY KEY (prod_id)
    );
CREATE TABLE Component (
    comp_id INT,
	comp_name VARCHAR(50) UNIQUE,
	description VARCHAR(50),
	quantity_comp INT,
	PRIMARY KEY (comp_id)
    );
CREATE TABLE Prod_Comp (
    prod_id INT , 
    comp_id INT , 
	quantity_comp INT,
	FOREIGN KEY (prod_id) REFERENCES Product(prod_id),
	FOREIGN KEY (comp_id) REFERENCES Component(comp_id)
	);
CREATE TABLE Supplier (
    supp_id INT NOT NULL,
	supp_name VARCHAR(50) NOT NULL,
	supp_location VARCHAR(50) NOT NULL,
	supp_country VARCHAR(50) NOT NULL,
	is_active bit DEFAULT 1,
	PRIMARY KEY (supp_id)
    );
CREATE TABLE Comp_Supp (
    supp_id INT ,
	comp_id INT , 
	order_date DATE,
	quantity INT,
	FOREIGN KEY (supp_id) REFERENCES Supplier(supp_id),
	FOREIGN KEY (comp_id) REFERENCES Component(comp_id)
    );    