--CREATE DATABASE Airport_Ticketing_SystemDB101

USE Airport_Ticketing_SystemDB101

-- Table to store countries with unique names
CREATE TABLE Countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(50) NOT NULL UNIQUE
);

-- Table to store cities, each linked to a country
-- Unique constraint ensures no duplicate city-country combinations
CREATE TABLE Cities (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id),
    CONSTRAINT uc_city_country UNIQUE(city_name, country_id)  
);
-- Table to store airports, each linked to a city
-- Airport codes must be unique e.g.,"LHR"
CREATE TABLE Airports (
    airport_id INT PRIMARY KEY,
    airport_code VARCHAR(3) NOT NULL UNIQUE,
    airport_name VARCHAR(100) NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES Cities(city_id)
);

-- Table to store flight routes between two different airports
-- Constraint ensures origin and destination can't be the same
CREATE TABLE Routes (
    route_id INT PRIMARY KEY,
    origin_airport_id INT,  
    destination_airport_id INT,  
    FOREIGN KEY (origin_airport_id) REFERENCES Airports(airport_id),  
    FOREIGN KEY (destination_airport_id) REFERENCES Airports(airport_id),  
    CONSTRAINT chk_origin_dest_different CHECK (origin_airport_id != destination_airport_id)  
);

-- Table to store airplane details like type, capacity, and manufacturer
CREATE TABLE Airplanes (
    airplane_id INT PRIMARY KEY,
    airplane_type VARCHAR(50) UNIQUE,
    capacity INT,
    manufacturer VARCHAR(50)
);

-- Table for scheduled flights, each linked to a route and airplane
-- Includes constraints on valid date ranges
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,    
    route_id INT,
      airplane_id INT,
    flight_number VARCHAR(10) NOT NULL UNIQUE,  
    departure_time DATETIME2,
    arrival_time DATETIME2,
    CONSTRAINT Date_check_FD CHECK (departure_time <  arrival_time),
      FOREIGN KEY (route_id) REFERENCES Routes(route_id),
    FOREIGN KEY (airplane_id) REFERENCES Airplanes(airplane_id)
);

-- Table to store address details for employees and passengers
CREATE TABLE Address (
    address_id INT PRIMARY KEY IDENTITY,
    street_address VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    region VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50)
);

-- Table to store employee details
-- Includes checks on email format, password length, and date logic
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(256) NOT NULL,
    role VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    address_id INT,
	date_joined DATE DEFAULT CAST(GETDATE() AS DATE),
	date_left DATE,
    CONSTRAINT chk_valid_email CHECK (email LIKE '%_@__%.__%'),
    CONSTRAINT chk_password_length CHECK (LEN(password) >= 8),
	CONSTRAINT chk_valid_dates CHECK (date_left IS NULL OR date_joined <= date_left),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

-- Logs employee permission or access requests
CREATE TABLE PermissionRequests (
    request_id INT PRIMARY KEY IDENTITY,
    employee_id INT,
    module_requested VARCHAR(100),
    request_time DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Table for passenger details with validations for email and DOB
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,  
    email VARCHAR(100),    
    dob DATE,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    passport_no VARCHAR(20),
    address_id INT,
    emergency_contact_number VARCHAR(20) NULL,
    CONSTRAINT chk_valid_email1 CHECK (email LIKE '%_@__%.__%'),
    CONSTRAINT chk_dob CHECK (dob <= GETDATE()),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

-- Table for different travel classes and their capacities
CREATE TABLE Travel_Class (
    travel_class_id INT PRIMARY KEY,  
    travel_class_name VARCHAR(50) NOT NULL UNIQUE,  
    travel_class_capacity INT NOT NULL,  
    CONSTRAINT chk_ticket_class CHECK (travel_class_name IN ('Business', 'First Class', 'Economy', 'Super Priority'))
);

-- Table for defining seat types
CREATE TABLE SeatTypes (
    seat_type_id INT PRIMARY KEY,  
    seat_type VARCHAR(50)
      );

-- Seat details linked to seat types; includes fee, availability, and assignment type
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY,
    seat_type_id INT,
      seat_number VARCHAR(10),
    preferred_seat BIT,
    availability_status VARCHAR(20) DEFAULT 'Available',
    seat_fee MONEY DEFAULT 0,
    seat_assignment VARCHAR(10) NULL,
    FOREIGN KEY (seat_type_id) REFERENCES SeatTypes(seat_type_id),
    CONSTRAINT chk_seat_fee CHECK (seat_fee >= 0),
    CONSTRAINT chk_preferred_seat CHECK (preferred_seat IN (0, 1)),
    CONSTRAINT chk_availability_status CHECK (availability_status IN ('Available', 'Reserved', 'Booked',  'Issued')),
    CONSTRAINT chk_seat_assignment CHECK (seat_assignment IN ('Standard', 'Preferred') OR seat_assignment IS NULL)  
);

-- Meal options per reservation, with fee and meal type constraints
CREATE TABLE Meals (
    meal_id INT PRIMARY KEY,
    upgraded_meal BIT,  
    meal_fee MONEY DEFAULT 0,  
    meal_type VARCHAR(50),  
      CONSTRAINT chk_meal_type CHECK (meal_type IN ('Vegetarian', 'Non-Vegetarian')),
      CONSTRAINT chk_meal_fee CHECK (meal_fee >= 0),
      
);


-- Baggage details with check-in status, weight, fee, and over-limit indicator
CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    baggage_weight DECIMAL(10, 2) CHECK (baggage_weight > 0 AND baggage_weight <= 1000),  
    check_in_status VARCHAR(20) CHECK(check_in_status IN ('Checked_in', 'Not_checked_in')),
    is_extra_baggage BIT,
    baggage_fee MONEY DEFAULT 0,  
    CONSTRAINT chk_baggage_fee CHECK (baggage_fee >= 0)
);

-- Reservation records with links to passenger, flight, seat, meal, class, and baggage
-- Includes constraints on reservation date and valid status
CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY,
      passenger_id INT,
    flight_id INT,  
    travel_class_id INT,
    seat_id INT,
    meal_id INT,
    baggage_id INT,
    reservation_date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    reservation_status VARCHAR(20) DEFAULT 'Pending',
      FOREIGN KEY (passenger_id) REFERENCES Passengers(Passenger_ID),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (travel_class_id) REFERENCES Travel_Class(travel_class_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id),
    FOREIGN KEY (meal_id) REFERENCES Meals(meal_id),
    FOREIGN KEY (baggage_id) REFERENCES Baggage(baggage_id),
    CONSTRAINT chk_reservation_date CHECK (reservation_date >= CAST(GETDATE() AS DATE)),
    CONSTRAINT chk_reservation_status CHECK ( reservation_status IN ('Pending', 'Confirmed', 'Cancelled'))
);

-- Stores PNR (Passenger Name Record) linked to a reservation
-- Used for booking and travel reference
CREATE TABLE PNR (
    pnr_id INT PRIMARY KEY,
    reservation_id INT,
    record_Locator VARCHAR(10) NOT NULL UNIQUE,
    booking_date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    booking_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    CHECK (booking_status IN ( 'Pending', 'Confirmed', 'Cancelled', 'No Show'))
);

-- Records payment details for each PNR with type and status
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    pnr_id INT,
    payment_date DATETIME2 NOT NULL DEFAULT GETDATE(),
    payment_amount MONEY NOT NULL,
    payment_method VARCHAR(50) NOT NULL,  
    payment_status VARCHAR(20) NOT NULL,  
    payment_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (pnr_id) REFERENCES PNR(PNR_ID),
    CONSTRAINT chk_payment_amount CHECK (payment_amount >= 0),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Paid', 'Pending', 'Failed', 'Cancelled'))
);

-- Tracks ticket issuance requests, linking payments and employees
CREATE TABLE Ticket_Issuance (
    ticket_issuance_id INT PRIMARY KEY,
    payment_id INT,
    employee_id INT,
    request_date DATETIME2 DEFAULT GETDATE(),
    ticket_issuance_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
      FOREIGN KEY (payment_id) REFERENCES Payments(payment_id),
    CONSTRAINT chk_status  CHECK (ticket_issuance_status IN ('Pending', 'Issued', 'Cancelled'))
);

-- Final issued ticket linked to ticket issuance and employee
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,  
    ticket_issuance_id INT,
    employee_id INT,
    eboarding_number VARCHAR(50) UNIQUE,  
    issuedate DATETIME2 NOT NULL DEFAULT GETDATE(),
      fare MONEY NOT NULL,
      CONSTRAINT chk_fare CHECK (fare >= 0),
    FOREIGN KEY (ticket_issuance_id) REFERENCES Ticket_Issuance(ticket_issuance_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
      );

-- Create triggers
-- Calculates extra baggage fee after inserting or updating a baggage record
CREATE TRIGGER trg_CalculateExtraBaggageFee
ON Baggage
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
-- Update the baggage fee if extra baggage is flagged and weight exceeds 45 kg
    UPDATE B
    SET baggage_fee =
        CASE
            WHEN I.is_extra_baggage = 1 AND I.baggage_weight > 45
            THEN (I.baggage_weight - 45) * 100 -- Fee = excess weight * 100
            ELSE 0
        END
    FROM Baggage B
    INNER JOIN inserted I ON B.baggage_id = I.baggage_id;
END;

-- Sets the meal fee to 20 if it is an upgraded meal
CREATE TRIGGER trg_SetUpgradedMealFee
ON Meals
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
-- Automatically set meal fee to 20 for upgraded meals
    UPDATE M
    SET meal_fee =
        CASE
            WHEN I.upgraded_meal = 1 THEN 20
            ELSE I.meal_fee  -- Keep existing fee if not upgraded
        END
    FROM Meals M
    INNER JOIN inserted I ON M.meal_id = I.meal_id;
END;

--Executes after a new reservation is inserted
CREATE TRIGGER trg_AfterReservationInsert
ON Reservations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update seat availability to 'Reserved'
    UPDATE S
    SET availability_status = 'Reserved'
    FROM Seats S
    INNER JOIN inserted I ON S.seat_id = I.seat_id;

    -- Automatically create a PNR record for the reservation
	INSERT INTO PNR (pnr_id, reservation_id, record_Locator, booking_date, booking_status)
    SELECT
        -- Generate a new PNR ID 
        ABS(CHECKSUM(NEWID())) % 1000000 + 1,  -- Randomized PNR ID between 1 and 1,000,000
        I.reservation_id,
        LEFT(CONVERT(VARCHAR(36), NEWID()), 10), -- Random 10-character record locator
        GETDATE(),
        'Pending'
    FROM inserted I;
END;

-- Executes after a payment is inserted
CREATE TRIGGER trg_AfterPaymentInsert
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Only process rows where payment status is 'Paid'
    IF EXISTS (SELECT 1 FROM inserted WHERE payment_status = 'Paid')
    BEGIN
        --  Update PNR status to 'Confirmed'
        UPDATE P
        SET booking_status = 'Confirmed'
        FROM PNR P
        INNER JOIN inserted I ON P.pnr_id = I.pnr_id
        WHERE I.payment_status = 'Paid';

        -- Update Reservation status to 'Confirmed'
        UPDATE R
        SET reservation_status = 'Confirmed'
        FROM Reservations R
        INNER JOIN PNR P ON R.reservation_id = P.reservation_id
        INNER JOIN inserted I ON P.pnr_id = I.pnr_id
        WHERE I.payment_status = 'Paid';

        -- Update Seat availability to 'Booked'
        UPDATE S
        SET availability_status = 'Booked'
        FROM Seats S
        INNER JOIN Reservations R ON S.seat_id = R.seat_id
        INNER JOIN PNR P ON R.reservation_id = P.reservation_id
        INNER JOIN inserted I ON P.pnr_id = I.pnr_id
        WHERE I.payment_status = 'Paid';
    END
END;

-- Ticket trigger
-- 6. Create Trigger on Ticket Table to Seat’s Availability Status Automatically 
CREATE TRIGGER trg_UpdateTicketIssuanceAndSeatsStatus 
ON Tickets
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update ticket issuance status
    UPDATE TI
    SET ticket_issuance_status = 'Issued'
    FROM Ticket_Issuance TI
    INNER JOIN inserted I ON TI.ticket_issuance_id = I.ticket_issuance_id;

    -- Update seat availability status via joined path
    UPDATE S
    SET availability_status = 'Issued'
    FROM Seats S
    INNER JOIN Reservations R ON S.seat_id = R.seat_id
    INNER JOIN PNR P ON R.reservation_id = P.reservation_id
	INNER JOIN Payments Py ON P.pnr_id = Py.pnr_id
    INNER JOIN Ticket_Issuance TI ON Py.payment_id = TI.payment_id
    INNER JOIN inserted I ON TI.ticket_issuance_id = I.ticket_issuance_id
	WHERE seat_assignment IS NOT NULL;
END;

-- Seats trigger
CREATE TRIGGER trg_SetPreferredSeatFee
ON Seats
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update seat_fee to 30 where preferred_seat = 1
    UPDATE S
    SET seat_fee = 30
    FROM Seats S
    INNER JOIN inserted I ON S.seat_id = I.seat_id
    WHERE I.preferred_seat = 1 AND I.seat_assignment IS NOT NULL ;
END
