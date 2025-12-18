--Views for Cross-Tables Functional Depenedence Auto Detection
CREATE OR ALTER VIEW vw_airport_geography AS
SELECT
    a.airport_id,
    a.airport_code,
    a.airport_name,
    c.city_id,
    c.city_name,
    co.country_id,
    co.country_name
FROM Airports a
JOIN Cities c ON a.city_id = c.city_id
JOIN Countries co ON c.country_id = co.country_id;

CREATE OR ALTER VIEW vw_flight_profile AS
SELECT
    f.flight_id,
    f.flight_number,
    f.departure_time,
    f.arrival_time,
    r.origin_airport_id,
    r.destination_airport_id,
    ap.airplane_type
FROM Flights f
JOIN Routes r ON f.route_id = r.route_id
JOIN Airplanes ap ON f.airplane_id = ap.airplane_id;

CREATE VIEW vw_reservation_profile AS
SELECT
    r.reservation_id,
    p.first_name,
	p.middle_name,
	p.last_name,
    f.flight_number,
    s.seat_number
FROM Reservations r
JOIN Passengers p ON r.passenger_id = p.passenger_id
JOIN Flights f ON r.flight_id = f.flight_id
JOIN Seats s ON r.seat_id = s.seat_id;

CREATE VIEW vw_employee_identity_profile AS
SELECT
    username,
    email,
    role
FROM Employees;
