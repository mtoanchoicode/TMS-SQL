DROP DATABASE IF EXISTS TransportationManagementSystem;
CREATE DATABASE TransportationManagementSystem;

USE TransportationManagementSystem;


-- Notifications ---------------------------------------------------------------------

-- Define the MessageTypes table to categorize different types of messages
CREATE TABLE MessageTypes (
    message_type_id INT PRIMARY KEY,          -- Unique identifier for the message type
    type_name VARCHAR(50) NOT NULL,           -- The name of the message type (e.g., "Alert", "Reminder")
    type_description VARCHAR(255) NOT NULL    -- A description of the message type
);

-- Define the MessageStatuses table to track the status of messages
CREATE TABLE MessageStatuses (
    message_status_id INT PRIMARY KEY,        -- Unique identifier for the message status
    status_name VARCHAR(50) NOT NULL,         -- Name of the message status (e.g., "Sent", "Failed", "Read")
    status_description VARCHAR(255) NOT NULL  -- A description of the status (e.g., "Message was successfully sent")
);

-- Define the Notifications table to store messages and their associated metadata
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY,          -- Unique identifier for the notification
    message VARCHAR(255) NOT NULL,            -- The content of the notification message
    message_type_id INT,                      -- References the MessageTypes table to specify the type of message
    message_status_id INT,                    -- References the MessageStatuses table to track the status of the message
    modified_date DATE NOT NULL,              -- Date when the notification was last modified
    FOREIGN KEY (message_type_id) REFERENCES MessageTypes(message_type_id),  -- Link to MessageTypes
    FOREIGN KEY (message_status_id) REFERENCES MessageStatuses(message_status_id)  -- Link to MessageStatuses
);

-- -----------------------------------------------------------------------------------

-- Users and Contact Information -----------------------------------------------------

-- Define the Contacts table to store information about contacts (e.g., customers, employees)
CREATE TABLE Contacts (
    contact_id INT PRIMARY KEY,                                 -- Unique identifier for the contact
    first_name VARCHAR(50) NOT NULL CHECK (first_name REGEXP '^[A-Z][a-z]*$'),  -- First name, starts with a capital letter
    last_name VARCHAR(50) NOT NULL CHECK (last_name REGEXP '^[A-Z][a-z]*$'),    -- Last name, starts with a capital letter
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'), -- Valid email address with check constraint
    phone_number VARCHAR(15) NOT NULL UNIQUE CHECK (phone_number REGEXP '^[+][0-9]{1,3}-[0-9]{3}-[0-9]{3}-[0-9]{4}$')  -- Valid phone number format with check constraint
);

-- Define the UserTypes table to categorize users based on their role
CREATE TABLE UserTypes (
    usertype_id INT PRIMARY KEY,                     -- Unique identifier for the user type
    user_role VARCHAR(50),                           -- Role name (e.g., "Admin", "Customer")
    user_role_description VARCHAR(255)              -- Description of the role
);

-- Define the Users table to store user account details
CREATE TABLE Users (
    user_id INT PRIMARY KEY,                         -- Unique identifier for each user
    contact_id INT,                                  -- References the Contacts table for the user's contact details
    usertype_id INT,                                 -- References the UserTypes table for the user role
    username VARCHAR(50) NOT NULL UNIQUE,             -- Unique username
    password VARCHAR(50) NOT NULL,                   -- User password
    last_login TIMESTAMP NOT NULL,                   -- Timestamp of the last login
    FOREIGN KEY (usertype_id) REFERENCES UserTypes(usertype_id),  -- Links to the UserTypes table
    FOREIGN KEY (contact_id) REFERENCES Contacts(contact_id)     -- Links to the Contacts table
);

-- Define the Employees table to store employee details
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,                     -- Unique identifier for the employee
    user_id INT UNIQUE,                               -- References the Users table for the user associated with the employee
    job_title VARCHAR(50) NOT NULL,                   -- Job title (e.g., "Manager", "Technician")
    date_of_birth DATE NOT NULL,                      -- Date of birth of the employee
    hire_date DATE NOT NULL,                          -- Date when the employee was hired
    FOREIGN KEY (user_id) REFERENCES Users(user_id)  -- Links to the Users table
);

-- Define the CustomerTypes table to store different types of customers (e.g., "VIP", "Regular")
CREATE TABLE CustomerTypes (
    customer_type_id INT PRIMARY KEY,                 -- Unique identifier for the customer type
    type_name VARCHAR(50) NOT NULL,                    -- Name of the customer type (e.g., "VIP", "Regular")
    type_description VARCHAR(255) NOT NULL             -- Description of the customer type
);

-- Define the Customers table to store customer details
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,                      -- Unique identifier for the customer
    customer_type_id INT,                             -- References the CustomerTypes table for the customer type
    user_id INT,                                      -- References the Users table for the user associated with the customer
    notification_id INT,                              -- References the Notifications table for the customer's notifications
    FOREIGN KEY (customer_type_id) REFERENCES CustomerTypes(customer_type_id),  -- Links to the CustomerTypes table
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id)     -- Links to the Notifications table
);

-- -----------------------------------------------------------------------------------

-- Warehouse and Inventory -----------------------------------------------------------

-- Define the WarehouseStaffPerformances table to track the performance evaluations of warehouse staff
CREATE TABLE WarehouseStaffPerformances (
    staff_performance_id INT PRIMARY KEY,            -- Unique identifier for the performance evaluation
    evaluation_date DATE NOT NULL,                    -- The date when the performance was evaluated
    rating INT NOT NULL CHECK (rating >= 0 AND rating <= 5),  -- Performance rating between 0 and 5
    comments VARCHAR(225) NOT NULL                    -- Comments about the staff performance
);

-- Define the WarehouseStaffs table to store information about warehouse staff members
CREATE TABLE WarehouseStaffs (
    warehouse_staff_id INT PRIMARY KEY,               -- Unique identifier for the warehouse staff member
    contact_id INT,                                   -- References the Contacts table for the staff member's contact information
    staff_performance_id INT,                         -- References the WarehouseStaffPerformances table for performance evaluations
    hire_date DATE NOT NULL,                          -- Date when the staff member was hired
    is_active ENUM('Yes', 'No'),                      -- Indicates if the staff member is active ('Yes' or 'No')
    FOREIGN KEY (contact_id) REFERENCES Contacts(contact_id),  -- Links to the Contacts table
    FOREIGN KEY (staff_performance_id) REFERENCES WarehouseStaffPerformances(staff_performance_id)  -- Links to the WarehouseStaffPerformances table
);

-- Define the WarehouseAddresses table to store warehouse address information
CREATE TABLE WarehouseAddresses (
    warehouse_address_id INT PRIMARY KEY,            -- Unique identifier for the warehouse address
    street VARCHAR(50) NOT NULL,                      -- Street name for the warehouse address
    city VARCHAR(50) NOT NULL,                        -- City for the warehouse address
    state VARCHAR(50) NOT NULL,                       -- State for the warehouse address
    postal_code VARCHAR(10) NOT NULL,                 -- Postal code for the warehouse address
    country VARCHAR(50) NOT NULL                      -- Country for the warehouse address
);

-- Define the WarehouseRegions table to store information about warehouse regions
CREATE TABLE WarehouseRegions (
    warehouse_region_id INT PRIMARY KEY,             -- Unique identifier for the warehouse region
    region_name VARCHAR(50) NOT NULL,                 -- Name of the region (e.g., "North", "South")
    country VARCHAR(50) NOT NULL                      -- Country for the warehouse region
);

-- Define the WarehouseStatuses table to store the status of the warehouse
CREATE TABLE WarehouseStatuses (
    warehouse_status_id INT PRIMARY KEY,             -- Unique identifier for the warehouse status
    status_name VARCHAR(50) NOT NULL,                 -- Status name (e.g., "Active", "Closed")
    status_description VARCHAR(255) NOT NULL          -- Description of the warehouse status
);

-- Define the Warehouses table to store warehouse information
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,                     -- Unique identifier for the warehouse
    warehouse_name VARCHAR(50) NOT NULL,               -- Name of the warehouse
    warehouse_capacity INT NOT NULL CHECK (warehouse_capacity >= 0),  -- Capacity of the warehouse
    warehouse_staff_id INT,                           -- References the WarehouseStaffs table for warehouse staff
    warehouse_address_id INT,                         -- References the WarehouseAddresses table for the warehouse address
    warehouse_region_id INT,                          -- References the WarehouseRegions table for the warehouse region
    warehouse_status_id INT,                          -- References the WarehouseStatuses table for the warehouse status
    FOREIGN KEY (warehouse_staff_id) REFERENCES WarehouseStaffs(warehouse_staff_id),  -- Links to the WarehouseStaffs table
    FOREIGN KEY (warehouse_address_id) REFERENCES WarehouseAddresses(warehouse_address_id),  -- Links to the WarehouseAddresses table
    FOREIGN KEY (warehouse_region_id) REFERENCES WarehouseRegions(warehouse_region_id),  -- Links to the WarehouseRegions table
    FOREIGN KEY (warehouse_status_id) REFERENCES WarehouseStatuses(warehouse_status_id)  -- Links to the WarehouseStatuses table
);

-- Define the SupplierTypes table to store different types of suppliers (e.g., Manufacturer, Distributor)
CREATE TABLE SupplierTypes (
    supplier_type_id INT PRIMARY KEY,                 -- Unique identifier for the supplier type
    type_name VARCHAR(50) UNIQUE NOT NULL,             -- Name of the supplier type (e.g., "Manufacturer", "Distributor")
    type_description VARCHAR(255) NOT NULL             -- Description of the supplier type
);

-- Define the Suppliers table to store supplier information
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,                      -- Unique identifier for the supplier
    supplier_type_id INT,                             -- References the SupplierTypes table for the supplier type
    contact_id INT,                                   -- References the Contacts table for the supplier's contact information
    rating INT CHECK (rating >= 0 AND rating <= 5),    -- Supplier rating between 0 and 5
    FOREIGN KEY (supplier_type_id) REFERENCES SupplierTypes(supplier_type_id),  -- Links to the SupplierTypes table
    FOREIGN KEY (contact_id) REFERENCES Contacts(contact_id)  -- Links to the Contacts table
);

-- Define the Inventories table to store inventory details in the warehouse
CREATE TABLE Inventories (
    inventory_id INT PRIMARY KEY,                     -- Unique identifier for the inventory item
    product_name VARCHAR(50) NOT NULL,                 -- Name of the product
    product_description VARCHAR(255) NOT NULL,         -- Description of the product
    quantity INT NOT NULL,                             -- Quantity of the product in stock
    unit_price INT NOT NULL,                           -- Unit price of the product
    total_value INT NOT NULL,                          -- Total value of the inventory (quantity * unit_price)
    reorder_level VARCHAR(50) NOT NULL,                -- Reorder level for the product (e.g., "Low", "Medium", "High")
    supplier_id INT,                                   -- References the Suppliers table for the supplier
    warehouse_id INT,                                  -- References the Warehouses table for the warehouse
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),  -- Links to the Suppliers table
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)  -- Links to the Warehouses table
);

-- Define the InventoryTransactions table to track inventory transactions (e.g., Restock, Shipping)
CREATE TABLE InventoryTransactions (
    inventory_transaction_id INT PRIMARY KEY,         -- Unique identifier for the inventory transaction
    inventory_id INT,                                  -- References the Inventories table for the inventory item
    transaction_type ENUM('Restock', 'Shipping', 'Adjustment') NOT NULL,  -- Type of transaction (e.g., "Restock", "Shipping")
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Date and time when the transaction occurred
    quantity INT NOT NULL,                             -- Quantity involved in the transaction
    transaction_amount DECIMAL(15, 2) NOT NULL CHECK (transaction_amount >= 0),  -- Amount of the transaction
    reason VARCHAR(255) NOT NULL,                       -- Reason for the transaction (e.g., "Restock", "Damaged")
    FOREIGN KEY (inventory_id) REFERENCES Inventories(inventory_id)  -- Links to the Inventories table
);


-- -----------------------------------------------------------------------------------

-- Vehicle Management ----------------------------------------------------------------

-- Define the VehicleStatuses table to store the statuses of vehicles (e.g., available, in repair)
CREATE TABLE VehicleStatuses (
    status_id INT PRIMARY KEY,                       -- Unique identifier for each vehicle status
    status_name VARCHAR(50) NOT NULL,                 -- Name of the status (e.g., "Available", "In Maintenance")
    status_description VARCHAR(255) NOT NULL          -- Description of the vehicle status
);

-- Define the VehicleTypes table to store vehicle type information (e.g., Truck, Van)
CREATE TABLE VehicleTypes (
    vehicle_type_id INT PRIMARY KEY,                  -- Unique identifier for each vehicle type
    type_name VARCHAR(50) NOT NULL,                    -- Name of the vehicle type (e.g., "Truck", "Van")
    type_description VARCHAR(255) NOT NULL             -- Description of the vehicle type
);

-- Define the Vehicles table to store vehicle information
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY,                       -- Unique identifier for each vehicle
    vehicle_type_id INT,                              -- References VehicleTypes table for the vehicle type
    vehicle_status_id INT,                            -- References VehicleStatuses table for the vehicle status
    year_of_manufacture DATE NOT NULL,                 -- The year the vehicle was manufactured
    color VARCHAR(50) NOT NULL,                        -- The color of the vehicle
    model VARCHAR(50) NOT NULL,                        -- The model of the vehicle
    capacity INT NOT NULL CHECK (capacity > 0),        -- Capacity of the vehicle (e.g., number of passengers or weight limit)
    FOREIGN KEY (vehicle_type_id) REFERENCES VehicleTypes(vehicle_type_id),  -- Links to the VehicleTypes table
    FOREIGN KEY (vehicle_status_id) REFERENCES VehicleStatuses(status_id)   -- Links to the VehicleStatuses table
);

-- Define the LicensePlates table to store license plate details for vehicles
CREATE TABLE LicensePlates (
    license_plate_id INT PRIMARY KEY,                 -- Unique identifier for each license plate
    vehicle_id INT,                                   -- References Vehicles table for the vehicle
    license_plate_num VARCHAR(20) NOT NULL UNIQUE,     -- License plate number (must be unique)
    issued_date DATE NOT NULL,                         -- Date when the license plate was issued
    issued_at VARCHAR(100) NOT NULL CHECK (issued_at REGEXP '^[A-Z][a-z]*$'),  -- Place of issuance (must match format)
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)  -- Links to the Vehicles table
);

-- Define the Carriers table to store carrier information, including contact details and vehicle assignments
CREATE TABLE Carriers (
    carrier_id INT PRIMARY KEY,                       -- Unique identifier for each carrier
    contact_id INT,                                   -- References Contacts table for the carrier's contact
    vehicle_id INT,                                   -- References Vehicles table for the vehicle assigned to the carrier
    carrier_address VARCHAR(50) NOT NULL,              -- Address of the carrier
    FOREIGN KEY (contact_id) REFERENCES Contacts(contact_id),  -- Links to the Contacts table
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)   -- Links to the Vehicles table
);

-- -----------------------------------------------------------------------------------

-- Route -----------------------------------------------------------------------------

-- Define the TrafficConditions table to store traffic condition information
CREATE TABLE TrafficConditions (
    traffic_condition_id INT PRIMARY KEY,           -- Unique identifier for each traffic condition
    condition_description VARCHAR(255) NOT NULL,    -- Description of the traffic condition (e.g., "Heavy traffic", "Clear roads")
    severity_level ENUM('Good', 'Bad'),             -- Severity level of the traffic condition (Good or Bad)
    reported_at DATE NOT NULL                       -- Date when the traffic condition was reported
);

-- Define the WeatherConditions table to store weather condition information
CREATE TABLE WeatherConditions (
    weather_condition_id INT PRIMARY KEY,           -- Unique identifier for each weather condition
    condition_description VARCHAR(255) NOT NULL,    -- Description of the weather condition (e.g., "Rainy", "Clear sky")
    temperature INT NOT NULL CHECK (temperature >= -50 AND temperature <= 50),  -- Temperature in Celsius, between -50 and 50 degrees
    humidity INT NOT NULL CHECK (humidity >= 0 AND humidity <= 100),           -- Humidity percentage, between 0 and 100
    wind_speed INT NOT NULL CHECK (wind_speed >= 0 AND wind_speed <= 300),    -- Wind speed in km/h, between 0 and 300 km/h
    reported_at DATE NOT NULL                       -- Date when the weather condition was reported
);

-- Define the Routes table to store route information
CREATE TABLE Routes (
    route_id INT PRIMARY KEY,                       -- Unique identifier for each route
    route_name VARCHAR(50) NOT NULL,                 -- Name of the route
    start_location VARCHAR(50) NOT NULL,             -- Starting location of the route
    end_location VARCHAR(50) NOT NULL,               -- Ending location of the route
    distance INT NOT NULL CHECK (distance > 0),      -- Distance of the route in kilometers, must be positive
    estimated_time TIME NOT NULL,                    -- Estimated time to travel the route
    route_status ENUM('Active', 'Inactive') NOT NULL CHECK (route_status IN ('Active', 'Inactive')),  -- Status of the route (Active or Inactive)
    traffic_condition_id INT,                        -- References TrafficConditions table for the traffic condition associated with the route
    weather_condition_id INT,                        -- References WeatherConditions table for the weather condition associated with the route
    vehicle_id INT,                                  -- References Vehicles table for the vehicle associated with the route
    FOREIGN KEY (traffic_condition_id) REFERENCES TrafficConditions(traffic_condition_id),  -- Links to the TrafficConditions table
    FOREIGN KEY (weather_condition_id) REFERENCES WeatherConditions(weather_condition_id),  -- Links to the WeatherConditions table
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)                             -- Links to the Vehicles table
);


-- -----------------------------------------------------------------------------------

-- Driver Management -----------------------------------------------------------------

-- Define the DriverStatuses table to store status information for drivers
CREATE TABLE DriverStatuses (
    driver_status_id INT PRIMARY KEY,              -- Unique identifier for each driver status
    status_name VARCHAR(50) NOT NULL,               -- Name of the driver status (e.g., "Active", "On Duty")
    status_description VARCHAR(255) NOT NULL        -- Detailed description of the driver status
);

-- Define the Drivers table to store details about the drivers
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,                     -- Unique identifier for each driver
    employee_id INT,                               -- References Employees table for the driver’s employee record
    warehouse_id INT,                              -- References Warehouses table for the assigned warehouse
    vehicle_id INT,                                -- References Vehicles table for the assigned vehicle
    driver_status_id INT,                          -- References DriverStatuses table for the current status of the driver
    driver_license VARCHAR(15) UNIQUE NOT NULL,    -- Unique driver license number for identification
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),       -- Links to the Employees table
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),     -- Links to the Warehouses table
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),           -- Links to the Vehicles table
    FOREIGN KEY (driver_status_id) REFERENCES DriverStatuses(driver_status_id) -- Links to the DriverStatuses table
);

-- -----------------------------------------------------------------------------------

-- Order -----------------------------------------------------------------------------

-- Define the DeliveryAddresses table to store customer delivery address information
CREATE TABLE DeliveryAddresses (
    delivery_address_id INT PRIMARY KEY,       -- Unique identifier for each delivery address
    street VARCHAR(50) NOT NULL,               -- Street name or address
    city VARCHAR(50) NOT NULL,                 -- City name
    state VARCHAR(50) NOT NULL,                -- State or province
    postal_code VARCHAR(10) NOT NULL,          -- Postal code for the address
    country VARCHAR(50) NOT NULL               -- Country of the delivery address
);

-- Define the OrderStatuses table to store status information for orders
CREATE TABLE OrderStatuses (
    order_status_id INT PRIMARY KEY,           -- Unique identifier for each order status
    status_name VARCHAR(50),                   -- Name of the order status (e.g., "Pending", "Shipped")
    status_description VARCHAR(255)            -- Description of the order status
);

-- Define the OrderRecords table to store order details made by customers
CREATE TABLE OrderRecords (
    order_id INT PRIMARY KEY,                  -- Unique identifier for each order
    customer_id INT,                            -- References Customers table for the customer placing the order
    warehouse_id INT,                           -- References Warehouses table for the warehouse processing the order
    delivery_address_id INT,                    -- References DeliveryAddresses table for the delivery address
    order_status_id INT,                        -- References OrderStatuses table for the status of the order
    notification_id INT NULL,                   -- References Notifications table for optional notification related to the order
    order_date DATE NOT NULL,                   -- Date the order was placed
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),       -- Links to the Customers table
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),     -- Links to the Warehouses table
    FOREIGN KEY (delivery_address_id) REFERENCES DeliveryAddresses(delivery_address_id), -- Links to the DeliveryAddresses table
    FOREIGN KEY (order_status_id) REFERENCES OrderStatuses(order_status_id),           -- Links to the OrderStatuses table
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id)             -- Links to the Notifications table
);

-- -----------------------------------------------------------------------------------

-- Billing and Payment ---------------------------------------------------------------

-- Define the PaymentMethods table to store different types of payment methods
CREATE TABLE PaymentMethods (
    payment_method_id INT PRIMARY KEY,                     -- Unique identifier for each payment method
    payment_type VARCHAR(50) NOT NULL,                     -- Type of payment (e.g., Credit Card, Cash)
    payment_description VARCHAR(255) NOT NULL              -- Detailed description of the payment method
);

-- Define the BillStatuses table to store status information for bills
CREATE TABLE BillStatuses (
    bill_status_id INT PRIMARY KEY,               -- Unique identifier for each bill status
    status_name VARCHAR(50) NOT NULL,             -- Name of the status (e.g., "Paid", "Pending")
    status_description VARCHAR(255) NOT NULL      -- Description of the bill status
);

-- Define the Transactions table to store information about financial transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,                       -- Unique identifier for each transaction
    trans_name VARCHAR(50) NOT NULL,                       -- Name of the transaction (e.g., "Payment", "Refund")
    trans_description VARCHAR(255) NOT NULL,              -- Detailed description of the transaction
    trans_type VARCHAR(50) NOT NULL,                       -- Type of the transaction (e.g., "Debit", "Credit")
    trans_code VARCHAR(10) UNIQUE NOT NULL,                -- Unique transaction code for identification
    trans_date DATE NOT NULL                               -- Date when the transaction occurred
);

-- Define the Payments table to store details of customer payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,                        -- Unique identifier for each payment
    customer_id INT,                                   -- References Customers table for the customer making the payment
    payment_method_id INT,                             -- References PaymentMethods table for the payment method used
    order_id INT,                                      -- References OrderRecords table for the associated order
    transaction_id INT,                                -- References Transactions table (optional) for transaction details
    payment_amount DECIMAL(15, 2) NOT NULL,            -- Amount paid by the customer
    payment_date DATE NOT NULL,                        -- Date the payment was made
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),                    -- Links to the Customers table
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods(payment_method_id),   -- Links to the PaymentMethods table
    FOREIGN KEY (order_id) REFERENCES OrderRecords(order_id),                       -- Links to the OrderRecords table
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)            -- Links to the Transactions table
);

-- Define the Bills table to store information related to customer bills
CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,                              -- Unique identifier for each bill
    order_id INT,                                         -- References OrderRecords table for the associated order
    delivery_address_id INT,                              -- References DeliveryAddresses table for the delivery location
    payment_method_id INT,                                -- References PaymentMethods table for the payment method used
    bill_status_id INT,                                   -- References BillStatuses table for the status of the bill
    total_amount DECIMAL(15, 2) NOT NULL,                 -- Total amount of the bill
    bill_date DATE NOT NULL,                              -- Date the bill was created
    distance INT NOT NULL CHECK (distance >= 0),          -- Delivery distance for the order (must be non-negative)
    FOREIGN KEY (order_id) REFERENCES OrderRecords(order_id),                        -- Links to the OrderRecords table
    FOREIGN KEY (delivery_address_id) REFERENCES DeliveryAddresses(delivery_address_id), -- Links to the DeliveryAddresses table
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods(payment_method_id),    -- Links to the PaymentMethods table
    FOREIGN KEY (bill_status_id) REFERENCES BillStatuses(bill_status_id)             -- Links to the BillStatuses table
);

-- Define the ReceiptStatuses table to store status information for receipts
CREATE TABLE ReceiptStatuses (
    receipt_status_id INT PRIMARY KEY,               -- Unique identifier for each receipt status
    status_name VARCHAR(50) NOT NULL,                 -- Name of the status (e.g., "Received", "Pending")
    status_description VARCHAR(255) NOT NULL          -- Description of the receipt status
);

-- Define the Receipts table to store details of supplier receipts
CREATE TABLE Receipts (
    receipt_id INT PRIMARY KEY,                       -- Unique identifier for each receipt
    supplier_id INT,                                  -- References Suppliers table for the supplier providing the goods
    payment_method_id INT,                            -- References PaymentMethods table for the payment method used
    warehouse_staff_id INT,                           -- References WarehouseStaffs table for the staff handling the receipt
    receipt_date DATE NOT NULL,                       -- Date the receipt was issued
    total_amount DECIMAL(15, 2) NOT NULL CHECK (total_amount >= 0), -- Total amount of the receipt
    items VARCHAR(255) NOT NULL,                      -- List of items included in the receipt
    receipt_status_id INT,                            -- References ReceiptStatuses table for the status of the receipt
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),               -- Links to the Suppliers table
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods(payment_method_id), -- Links to the PaymentMethods table
    FOREIGN KEY (warehouse_staff_id) REFERENCES WarehouseStaffs(warehouse_staff_id), -- Links to the WarehouseStaffs table
    FOREIGN KEY (receipt_status_id) REFERENCES ReceiptStatuses(receipt_status_id) -- Links to the ReceiptStatuses table
);

-- Define the RemainingStatuses table to store status information for remaining payments
CREATE TABLE RemainingStatuses (
    remaining_status_id INT PRIMARY KEY,             -- Unique identifier for each remaining payment status
    status_name VARCHAR(50) NOT NULL,                 -- Status name (e.g., Partial, Pending)
    status_description VARCHAR(255) NOT NULL          -- Description of the remaining payment status
);

-- Define the RemainingPayments table to store information about remaining amounts to be paid
CREATE TABLE RemainingPayments (
    remaining_id INT PRIMARY KEY,                     -- Unique identifier for each remaining payment
    bill_id INT,                                      -- References Bills table for the associated bill
    remaining_status_id INT,                          -- References RemainingStatuses table for the status of the remaining payment
    payment_id INT,                                   -- References Payments table for the payment made towards the remaining amount
    remaining_amount DECIMAL(15, 2) NOT NULL,         -- Amount left to be paid
    FOREIGN KEY (bill_id) REFERENCES Bills(bill_id),               -- Links to the Bills table
    FOREIGN KEY (remaining_status_id) REFERENCES RemainingStatuses(remaining_status_id), -- Links to the RemainingStatuses table
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)     -- Links to the Payments table
);

-- Define the Consignees table to store information of consignee
CREATE TABLE Consignees (
    consignee_id INT PRIMARY KEY,       -- Unique identifier for each shipment 
    user_id INT,                        -- user_id associate with Log in user
    delivery_address_id INT,            -- delivery_address_id associate with address to deliver
    order_id INT,                       -- order_id associate with each order
    notification_id INT NULL,           -- notification_id associate with notification sent to consignee
    FOREIGN KEY (user_id) REFERENCES Users(user_id),         -- Linking consignee with user account
    FOREIGN KEY (delivery_address_id) REFERENCES DeliveryAddresses(delivery_address_id), -- Linking consignee address with address table
    FOREIGN KEY (order_id) REFERENCES OrderRecords(order_id), -- Linking consignee with their order
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id) -- Linking consignee notification with notification table
);

-- -----------------------------------------------------------------------------------

-- Shipment --------------------------------------------------------------------------

-- Define the ShipmentStatuses table to store status information for shipments
CREATE TABLE ShipmentStatuses (
    shipment_status_id INT PRIMARY KEY,               -- Unique identifier for each shipment status
    status_name VARCHAR(50) NOT NULL,                 -- Name of the status (e.g., "In Transit")
    status_description VARCHAR(255) NOT NULL          -- Description of the status
);


-- Define the Shipments table to store information about each shipment
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,                          -- Unique identifier for each shipment                                      
    route_id INT,                                         -- Route associated with the shipment
    driver_id INT,                                        -- Driver associated with the shipment
    shipment_status_id INT,                               -- Status of the shipment (linked to ShipmentStatuses)
    notification_id INT,                                  -- Notification ID for updates related to the shipment
    estimated_delivery_date DATE,                         -- Estimated delivery date
    actual_delivery_date DATE,                            -- Actual delivery date (if available)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,       -- Timestamp for when the shipment record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Timestamp for the last update of the shipment record
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),     -- Linking the driver to the shipment
    FOREIGN KEY (shipment_status_id) REFERENCES ShipmentStatuses(shipment_status_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),    -- Linking the shipment to a specific route
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id) -- Links notification with shipment
);

-- Define the ShipmentRouteDetails table to link shipments with routes and delivery addresses
CREATE TABLE ShipmentRouteDetails (
    shipment_id INT,                                      -- Shipment identifier
    route_id INT,                                         -- Route associated with the shipment
    delivery_address_id INT,                              -- Delivery address for the shipment
    PRIMARY KEY (shipment_id, route_id),                  -- Composite primary key to ensure unique shipment-route pairs
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id), -- Links to the Shipments table
    FOREIGN KEY (route_id) REFERENCES Routes(route_id),           -- Links to the Routes table
    FOREIGN KEY (delivery_address_id) REFERENCES DeliveryAddresses(delivery_address_id) -- Links to the DeliveryAddresses table
);

---------------------------------------------------------------------------------------