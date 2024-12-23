-- Create country table
CREATE TABLE country (
    id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
    country_name VARCHAR(255) NOT NULL,  -- Country name, unique and cannot be null
    CONSTRAINT country_name_unique UNIQUE (country_name)  -- Ensure country name is unique
);

-- Define card type enum
CREATE TYPE card_type_enum AS ENUM ('Visa', 'MasterCard', 'Amex', 'Discover', 'Other');

-- Create card type table
CREATE TABLE card_type (
    id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
    card_type_name card_type_enum NOT NULL  -- Card type must be one of the predefined values
);

-- Create customer table
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
    NIN VARCHAR(20) UNIQUE NOT NULL,  -- National ID, unique and cannot be null
    first_name VARCHAR(100) NOT NULL,  -- Customer's first name
    last_name VARCHAR(100) NOT NULL,  -- Customer's last name
    country_id INT NOT NULL,  -- Foreign key referencing country
    CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES country(id) ON DELETE CASCADE,  -- Ensure referential integrity for country
    CONSTRAINT NIN_check CHECK (NIN ~ '^[0-9]{8,20}$')  -- Validate NIN format (8-20 digits)
);

-- Create card number table
CREATE TABLE card_number (
    id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
    card_number VARCHAR(19) UNIQUE NOT NULL,  -- Card number (13-19 digits), unique
    customer_id INT NOT NULL,  -- Foreign key referencing customer
    card_type_id INT NOT NULL,  -- Foreign key referencing card type
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE,  -- Ensure referential integrity for customer
    CONSTRAINT fk_card_type FOREIGN KEY (card_type_id) REFERENCES card_type(id) ON DELETE CASCADE,  -- Ensure referential integrity for card type
    CONSTRAINT card_number_check CHECK (card_number ~ '^[0-9]{13,19}$')  -- Validate card number format (13-19 digits)
);

-- Create card transaction table
CREATE TABLE card_transaction (
    id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
    date TIMESTAMP NOT NULL,  -- Transaction date and time
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),  -- Transaction amount (positive value)
    card_number_id INT NOT NULL,  -- Foreign key referencing card number
    CONSTRAINT fk_card_number FOREIGN KEY (card_number_id) REFERENCES card_number(id) ON DELETE CASCADE  -- Ensure referential integrity for card number
);
