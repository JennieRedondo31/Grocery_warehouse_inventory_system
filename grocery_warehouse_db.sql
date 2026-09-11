CREATE DATABASE IF NOT EXISTS `grocery_warehouse_db`;
USE `grocery_warehouse_db`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `AuditLog`;
DROP TABLE IF EXISTS `Product`;
DROP TABLE IF EXISTS `Bin`;
DROP TABLE IF EXISTS `Shelf`;
DROP TABLE IF EXISTS `Aisle`;
DROP TABLE IF EXISTS `Category`;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS `Role`;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `Role` (
    `RoleID` INT AUTO_INCREMENT PRIMARY KEY,
    `RoleName` VARCHAR(100) NOT NULL UNIQUE,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE `Category` (
    `CategoryID` INT AUTO_INCREMENT PRIMARY KEY,
    `CategoryName` VARCHAR(100) NOT NULL UNIQUE,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE `Aisle` (
    `AisleID` INT AUTO_INCREMENT PRIMARY KEY,
    `AisleCode` VARCHAR(50) NOT NULL UNIQUE,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE `Shelf` (
    `ShelfID` INT AUTO_INCREMENT PRIMARY KEY,
    `AisleID` INT NOT NULL,
    `ShelfCode` VARCHAR(50) NOT NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (`AisleID`) REFERENCES `Aisle`(`AisleID`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (`AisleID`, `ShelfCode`)
);

CREATE TABLE `Bin` (
    `BinID` INT AUTO_INCREMENT PRIMARY KEY,
    `ShelfID` INT NOT NULL,
    `BinCode` VARCHAR(50) NOT NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (`ShelfID`) REFERENCES `Shelf`(`ShelfID`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (`ShelfID`, `BinCode`)
);

CREATE TABLE `Product` (
    `ProductID` INT AUTO_INCREMENT PRIMARY KEY,
    `SKU` VARCHAR(100) NOT NULL UNIQUE,
    `Barcode` VARCHAR(100) DEFAULT NULL UNIQUE,
    `ProductName` VARCHAR(200) NOT NULL,
    `Description` TEXT,
    `UnitOfMeasure` VARCHAR(50) NOT NULL,
    `MinStockLevel` INT NOT NULL DEFAULT 0,
    `BinID` INT NOT NULL,
    `CategoryID` INT NOT NULL,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (`BinID`) REFERENCES `Bin`(`BinID`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`CategoryID`) REFERENCES `Category`(`CategoryID`)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE `User` (
    `UserID` INT AUTO_INCREMENT PRIMARY KEY,
    `UserName` VARCHAR(100) NOT NULL UNIQUE,
    `Password` VARCHAR(255) NOT NULL,
    `FirstName` VARCHAR(100) NOT NULL,
    `LastName` VARCHAR(100) NOT NULL,
    `Email` VARCHAR(150) NOT NULL UNIQUE,
    `RoleID` INT NOT NULL,
    `UserStatus` ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`RoleID`) REFERENCES `Role`(`RoleID`)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE `AuditLog` (
    `AuditLogID` INT AUTO_INCREMENT PRIMARY KEY,
    `UserID` INT NOT NULL,
    `ActionType` VARCHAR(100) NOT NULL,
    `TableAffected` VARCHAR(100) NOT NULL,
    `ActionTimestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Details` TEXT,
    FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO `Role` (`RoleName`, `IsActive`) VALUES
('Admin', 1),
('Warehouse Manager', 1),
('Staff', 1);

INSERT INTO `Category` (`CategoryName`, `IsActive`) VALUES
('Beverages', 1),
('Canned Goods', 1),
('Snacks', 1),
('Dairy', 1),
('Frozen Foods', 1),
('Personal Care', 1),
('Household', 1);

INSERT INTO `Aisle` (`AisleCode`, `IsActive`) VALUES
('A01', 1),
('A02', 1),
('A03', 1);

INSERT INTO `Shelf` (`AisleID`, `ShelfCode`, `IsActive`) VALUES
(1, 'S01', 1),
(1, 'S02', 1),
(2, 'S01', 1),
(2, 'S02', 1),
(3, 'S01', 1);

INSERT INTO `Bin` (`ShelfID`, `BinCode`, `IsActive`) VALUES
(1, 'B01', 1),
(1, 'B02', 1),
(2, 'B01', 1),
(3, 'B01', 1),
(4, 'B01', 1),
(5, 'B01', 1);

INSERT INTO `Product`
(`SKU`, `Barcode`, `ProductName`, `Description`, `UnitOfMeasure`,
 `MinStockLevel`, `BinID`, `CategoryID`, `IsActive`)
VALUES
('SKU-001', '480000000001', 'Bottled Water', '500ml bottled water', 'Piece', 20, 1, 1, 1),
('SKU-002', '480000000002', 'Canned Sardines', '155g canned sardines', 'Can', 15, 2, 2, 1),
('SKU-003', '480000000003', 'Potato Chips', 'Regular potato chips', 'Pack', 10, 3, 3, 1),
('SKU-004', '480000000004', 'Fresh Milk', '1L fresh milk', 'Bottle', 10, 4, 4, 1),
('SKU-005', '480000000005', 'Frozen Chicken', '1kg frozen chicken', 'Pack', 8, 5, 5, 1);

INSERT INTO `User`
(`UserName`, `Password`, `FirstName`, `LastName`, `Email`, `RoleID`, `UserStatus`)
VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC4Yx1W4X5lJ2bX8fQyS',
 'System', 'Administrator', 'admin@gmail.com', 1, 'Active');

INSERT INTO `AuditLog`
(`UserID`, `ActionType`, `TableAffected`, `Details`)
VALUES
(1, 'SYSTEM', 'Database', 'Initial grocery warehouse database setup');

SELECT 'Database setup completed successfully.' AS Message;
 