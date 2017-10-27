USE travel;

-- 1. Select a distinct list of ordered airports codes. 

SELECT DISTINCT f.departAirport as Airports FROM flight f ORDER BY f.departAirport;

-- 2. Provide a list of delayed flights departing from San Francisco (SFO).

SELECT a.name, f.flightNumber, f.scheduledDepartDateTime, f.arriveAirport, f.status 
FROM flight f 
INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.status = 'delayed' and f.departAirport = 'SFO';

-- 3. Provide a distinct list of cities that American airlines departs from.

SELECT DISTINCT f.departAirport as Cities 
FROM flight f 
INNER JOIN airline a ON f.airlineID = a.ID
WHERE a.name = 'American'
ORDER BY f.departAirport;

-- 4. Provide a distinct list of airlines that conduct flights departing from ATL.

SELECT DISTINCT a.name Airline
FROM flight f 
INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.departAirport = 'ATL'
ORDER BY a.name;

-- 5. Provide a list of airlines, flight numbers, departing airports, and arrival airports where flights departed on time.

SELECT a.name, f.flightNumber, f.departAirport, f.arriveAirport
FROM flight f
INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.scheduledDepartDateTime = f.actualDepartDateTime;


-- 6. Provide a list of airlines, flight numbers, gates, status, and arrival times arriving into Charlotte (CLT) on 10-30-2017. 
--    Order your results by the arrival time.

SELECT a.name as Airline, f.flightNumber as Flight, f.gate as Gate, time(f.scheduledArriveDateTime) as Arrival, f.status as Status
FROM flight f
INNER JOIN airline a ON f.airlineID = a.ID
WHERE f.arriveAirport = 'CLT' and date(f.scheduledArriveDateTime) = date('2017-10-30')
ORDER BY f.scheduledArriveDateTime;

-- 7. List the number of reservations by flight number. Order by reservations in descending order.

SELECT f.flightNumber as flight, count(r.id) as reservations
FROM reservation r
INNER JOIN flight f ON r.flightID = f.ID
GROUP BY f.flightNumber
ORDER BY reservations DESC;

-- 8. List the average ticket cost for coach by airline and route. Order by AverageCost in descending order.

SELECT a.name as airline, f.departAirport, f.arriveAirport, AVG(r.cost) as AverageCost
FROM reservation r
INNER JOIN flight f ON r.flightID = f.ID
INNER JOIN airline a ON f.airlineID = a.id
WHERE r.class = 'coach'
GROUP BY f.airlineID, concat(f.departAirport,f.arriveAirport)
ORDER BY AverageCost DESC;

-- 9. Which route is the longest?

SELECT f.departAirport, f.arriveAirport, f.miles
FROM flight f
ORDER BY f.miles DESC
LIMIT 1;

-- 10. List the top 5 passengers that have flown the most miles. Order by miles.

SELECT p.firstName, p.lastName, SUM(f.miles) as miles
FROM passenger p
INNER JOIN reservation r ON p.id = r.passengerID
INNER JOIN flight f ON r.flightID = f.ID
GROUP BY p.ID
ORDER BY miles DESC, p.firstName
LIMIT 5;

-- 11. Provide a list of upcoming scheduled American airline flights ordered by route and arrival date and time.

SELECT a.name as Name, concat(f.departAirport,' --> ',f.arriveAirport) as Route, date(f.scheduledArriveDateTime) as 'Arrive Date', time(f.scheduledArriveDateTime) as 'Arrive Time'
FROM flight f
INNER JOIN airline a ON f.airlineID = a.ID
WHERE a.name = 'American' 
ORDER BY Route, f.scheduledArriveDateTime ASC;

-- 12. Provide a report that counts the number of reservations and totals the reservation costs (as Revenue) 
--     by Airline, flight, and route. Order the report by total revenue in descending order.

SELECT a.name as Airline, f.flightNumber as Flight, concat(f.departAirport,' --> ',f.arriveAirport) as Route, count(f.id) as 'Reservation Count', sum(r.cost) as Revenue
FROM reservation r
INNER JOIN flight f ON r.flightID = f.ID
INNER JOIN airline a ON f.airlineID = a.id
GROUP BY f.airlineID, f.flightNumber, Route
ORDER BY Revenue DESC;


-- 13. List the average cost per reservation by route. Round results down to the dollar.
SELECT concat(f.departAirport,' --> ',f.arriveAirport) as Route, floor(avg(r.cost)) as 'Avg Revenue'
FROM reservation r
INNER JOIN flight f ON r.flightID = f.ID
GROUP BY Route
ORDER BY avg(r.cost) DESC;



-- 14. List the average miles per flight by airline.

SELECT a.name as Airline, avg(f.miles) as 'Avg Miles Per Flight'
FROM airline a 
INNER JOIN flight f ON a.id = f.airlineID
GROUP BY a.id
ORDER BY a.name;

-- 15. Which airlines had flights that arrived early?

SELECT a.name as Airline
FROM airline a
INNER JOIN flight f on a.id = f.airlineID
WHERE f.actualArriveDateTime < f.scheduledArriveDateTime
GROUP BY a.id
