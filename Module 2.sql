USE mydb;
DROP VIEW IF EXISTS OrdersView;
CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost
FROM Orders
WHERE Quantity>2;

DROP VIEW IF EXISTS CostView;
CREATE VIEW CostView AS
SELECT Customers.CustomerID, 
CONCAT(Customers.FirstName, ' ', Customers.LastName) AS FullName,
Orders.OrderID,
Orders.TotalCost,
Menus.MenuName,
Menus.Cuisine
FROM Customers
INNER JOIN Orders ON Orders.CustomerID=Customers.CustomerID
INNER JOIN Menus ON Orders.ItemID=Menus.MenuID
WHERE Orders.TotalCost>150;

DROP VIEW IF EXISTS MoreThanTwo;
CREATE VIEW MoreThanTwo AS
SELECT MenuName
FROM Menus
WHERE (SELECT Count(MenuItemsID) FROM Menus HAVING Count(MenuItemsID)>2);

SELECT * FROM OrdersView;
SELECT * FROM CostView;
SELECT * FROM MoreThanTwo;

DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
SELECT MAX(Quantity) AS 'Max Quantity In Order'
FROM Orders;
END//
DELIMITER ;

CALL GetMaxQuantity;

PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID=?';

SET @id=1;
EXECUTE GetOrderDetail USING @id;

DROP PROCEDURE IF EXISTS CancelOrder;
DELIMITER //
CREATE PROCEDURE CancelOrder(IN ID INT)
BEGIN
DELETE FROM Orders WHERE OrderID=ID;
END//
DELIMITER ;

CALL CancelOrder(1);

DROP PROCEDURE IF EXISTS CheckBooking;
DELIMITER //
CREATE PROCEDURE CheckBooking(IN bookedDate DATE, IN tableNum INT)
BEGIN
SELECT IF(EXISTS(SELECT * FROM Bookings WHERE Date=bookedDate AND TableNum=tableNum), 'Already Booked', 'Not Booked')
AS 'Booking Status';
END//
DELIMITER ;

CALL CheckBooking('2022-11-12', 3);

DROP PROCEDURE IF EXISTS AddValidBooking;
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN bookedDate DATE, IN tableNum INT)
BEGIN
START TRANSACTION;
IF(EXISTS(SELECT * FROM Bookings WHERE Date=bookedDate AND TableNum=tableNum))
THEN
SELECT 'Booking Cancelled' AS 'Booking Status';
ELSE
INSERT INTO Bookings(Date, TableNum) VALUES (bookedDate, tableNum);
END IF;
COMMIT;
END//
DELIMITER ;

CALL AddValidBooking('2022-10-10', 5);

DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(IN newID INT, in custID INT, IN bookedDate DATE, IN tableNum INT)
BEGIN
INSERT INTO Bookings(BookingID, Date, TableNum, CustomerID) VALUES (newID, bookeddate, tableNum, custID);
END//
DELIMITER ;

CALL AddBooking(9, 3, '2022-12-30', 4);

DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN updateID INT, IN bookedDate DATE)
BEGIN
SELECT IF(EXISTS(SELECT * FROM Bookings WHERE Date=bookedDate AND BookingID=updateID), 'Updated', 'Failed to update')
AS 'Confirmation';
END//
DELIMITER ;

CALL UpdateBooking(9, '2022-12-17');

DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN remID INT)
BEGIN
DELETE FROM Bookings WHERE BookingID=remID;
END//
DELIMITER ;

CALL CancelBooking(9);