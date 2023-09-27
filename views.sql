-- Запросы для создания представлений из схемы production в схему analysis

--Представление Users
CREATE VIEW analysis.Users AS
SELECT * FROM production.Users;

--Представление OrderItems
CREATE VIEW analysis.OrderItems AS
SELECT * FROM production.OrderItems;

--Представление OrderStatuses
CREATE VIEW analysis.OrderStatuses AS
SELECT * FROM production.OrderStatuses;

--Представление Products
CREATE VIEW analysis.Products AS
SELECT * FROM production.Products;

--Представление Orders
CREATE VIEW analysis.Orders AS
SELECT * FROM production.Orders;
