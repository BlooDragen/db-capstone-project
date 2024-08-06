INSERT INTO Customers
VALUES (1, 'Dan', 'Smitty', '111-222-3333', 'dansmitty@dan.com'),
(2, 'Danielle', 'Smitterson', '121-232-3443', 'femsmitty@dan.com'),
(3, 'Dancer', 'Smiths', '212-323-4334', 'thepower@dan.com'),
(4, 'Danathan', 'Smits', '333-222-1111', 'jimothy@dan.com');

INSERT INTO Bookings(BookingID, Date, TableNum, CustomerID)
VALUES (1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

SELECT * FROM Bookings;