




 Functional Dependency Targets

This document defines expected functional dependencies derived from
the airport ticketing database schema and business rules.

Airports
- airport_id → airport_code, airport_name, city_id
- airport_code → airport_id, airport_name, city_id

Cities
- city_id → city_name, country_id
- (city_name, country_id) → city_id

Countries
- country_id → country_name
- country_name → country_id

Flights
- flight_id → route_id, airplane_id, flight_number, departure_time, arrival_time
- flight_number → flight_id

Reservations
-reservation_id → passenger_name, flight_number, seat_number
-seat_number → flight_number
Payment
-pnr_code → payment_amount
-pnr_code → payment_status
Employee
-username → email, role
-email → username

These targets are used to validate FD discovery results.



