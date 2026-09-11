-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 11, 2026 at 03:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `grocery_warehouse_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `aisle`
--

CREATE TABLE `aisle` (
  `AisleID` int(11) NOT NULL,
  `AisleCode` varchar(50) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aisle`
--

INSERT INTO `aisle` (`AisleID`, `AisleCode`, `IsActive`) VALUES
(1, 'A1', 1),
(2, 'A2', 1),
(3, 'A3', 1),
(4, 'A4', 1);

-- --------------------------------------------------------

--
-- Table structure for table `auditlog`
--

CREATE TABLE `auditlog` (
  `AuditLogID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `ActionType` varchar(100) NOT NULL,
  `TableAffected` varchar(100) NOT NULL,
  `ActionTimestamp` datetime DEFAULT current_timestamp(),
  `Details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auditlog`
--

INSERT INTO `auditlog` (`AuditLogID`, `UserID`, `ActionType`, `TableAffected`, `ActionTimestamp`, `Details`) VALUES
(1, 1, 'CREATE', 'Product', '2026-09-10 22:06:14', 'Added Fresh Bananas'),
(2, 3, 'CREATE', 'Purchase_Order', '2026-09-10 22:06:14', 'Created purchase order for grocery products'),
(3, 2, 'UPDATE', 'Receiving', '2026-09-10 22:06:14', 'Updated receiving record'),
(4, 6, 'CREATE', 'User', '2026-09-10 23:54:07', 'Created user: jenn');

-- --------------------------------------------------------

--
-- Table structure for table `bin`
--

CREATE TABLE `bin` (
  `BinID` int(11) NOT NULL,
  `ShelfID` int(11) NOT NULL,
  `BinCode` varchar(50) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bin`
--

INSERT INTO `bin` (`BinID`, `ShelfID`, `BinCode`, `IsActive`) VALUES
(1, 1, 'A1-S1-B1', 1),
(2, 1, 'A1-S1-B2', 1),
(3, 2, 'A1-S2-B1', 1),
(4, 3, 'A2-S1-B1', 1),
(5, 4, 'A3-S1-B1', 1),
(6, 5, 'A4-S1-B1', 1),
(7, 6, 'A4-S2-B1', 1),
(8, 6, 'A4-S2-B2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `CategoryID` int(11) NOT NULL,
  `CategoryName` varchar(100) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryID`, `CategoryName`, `IsActive`) VALUES
(1, 'Fresh Produce', 1),
(2, 'Dairy & Eggs', 1),
(3, 'Canned & Packaged Goods', 1),
(4, 'Beverages', 1),
(5, 'Snacks & Confectionery', 1);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_adjustment`
--

CREATE TABLE `inventory_adjustment` (
  `Adjustment_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Adjustment_Date` date NOT NULL,
  `Reason` varchar(255) DEFAULT NULL,
  `Status_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_adjustment`
--

INSERT INTO `inventory_adjustment` (`Adjustment_ID`, `User_ID`, `Adjustment_Date`, `Reason`, `Status_ID`) VALUES
(1, 2, '2026-09-07', 'Physical count difference', 3);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_adjustment_line`
--

CREATE TABLE `inventory_adjustment_line` (
  `Adjustment_Line_ID` int(11) NOT NULL,
  `Adjustment_ID` int(11) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  `System_Quantity` int(11) NOT NULL,
  `Actual_Quantity` int(11) NOT NULL,
  `Adjustment_Quantity` int(11) NOT NULL,
  `Adjustment_Type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_adjustment_line`
--

INSERT INTO `inventory_adjustment_line` (`Adjustment_Line_ID`, `Adjustment_ID`, `Product_ID`, `System_Quantity`, `Actual_Quantity`, `Adjustment_Quantity`, `Adjustment_Type`) VALUES
(1, 1, 5, 50, 47, -3, 'Decrease');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `ProductID` int(11) NOT NULL,
  `SKU` varchar(50) NOT NULL,
  `Barcode` varchar(50) NOT NULL,
  `ProductName` varchar(150) NOT NULL,
  `Description` text DEFAULT NULL,
  `UnitOfMeasure` varchar(50) NOT NULL,
  `MinStockLevel` int(11) DEFAULT 0,
  `CreatedAt` datetime DEFAULT current_timestamp(),
  `BinID` int(11) NOT NULL,
  `CategoryID` int(11) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductID`, `SKU`, `Barcode`, `ProductName`, `Description`, `UnitOfMeasure`, `MinStockLevel`, `CreatedAt`, `BinID`, `CategoryID`, `IsActive`) VALUES
(1, 'GRC-001', '4801234567890', 'Fresh Bananas', 'Fresh Cavendish bananas', 'kg', 30, '2026-09-10 22:06:14', 1, 1, 1),
(2, 'GRC-002', '4801234567891', 'Fresh Milk 1L', 'Full cream fresh milk', 'bottle', 40, '2026-09-10 22:06:14', 2, 2, 1),
(3, 'GRC-003', '4801234567892', 'Corned Beef 210g', 'Canned corned beef', 'can', 60, '2026-09-10 22:06:14', 3, 3, 1),
(4, 'GRC-004', '4801234567893', 'Bottled Water 500mL', 'Purified drinking water', 'bottle', 100, '2026-09-10 22:06:14', 4, 4, 1),
(5, 'GRC-005', '4801234567894', 'Potato Chips 150g', 'Original flavored potato chips', 'pack', 50, '2026-09-10 22:06:14', 5, 5, 1),
(6, 'GRC-006', '4801234567895', 'Premium Rice 5kg', 'Premium quality white rice', 'sack', 30, '2026-09-10 22:06:14', 6, 3, 1),
(7, 'GRC-007', '4801234567896', 'Instant Noodles', 'Chicken flavored instant noodles', 'pack', 80, '2026-09-10 22:06:14', 7, 3, 1),
(8, 'GRC-008', '4801234567897', 'Canned Sardines 155g', 'Tomato sauce sardines', 'can', 70, '2026-09-10 22:06:14', 8, 3, 1),
(9, 'GRC-009', '4801234567898', 'Cooking Oil 1L', 'Vegetable cooking oil', 'bottle', 40, '2026-09-10 22:06:14', 1, 3, 1),
(10, 'GRC-010', '4801234567899', 'White Sugar 1kg', 'Refined white sugar', 'pack', 40, '2026-09-10 22:06:14', 2, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order`
--

CREATE TABLE `purchase_order` (
  `PO_ID` int(11) NOT NULL,
  `Supplier_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `PO_Date` date NOT NULL,
  `Expected_Date` date DEFAULT NULL,
  `Status_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_order`
--

INSERT INTO `purchase_order` (`PO_ID`, `Supplier_ID`, `User_ID`, `PO_Date`, `Expected_Date`, `Status_ID`) VALUES
(1, 1, 3, '2026-09-01', '2026-09-03', 2),
(2, 2, 3, '2026-09-02', '2026-09-04', 2),
(3, 3, 3, '2026-09-03', '2026-09-05', 1);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_line`
--

CREATE TABLE `purchase_order_line` (
  `PO_Line_ID` int(11) NOT NULL,
  `PO_ID` int(11) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Unit_Price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_order_line`
--

INSERT INTO `purchase_order_line` (`PO_Line_ID`, `PO_ID`, `Product_ID`, `Quantity`, `Unit_Price`) VALUES
(1, 1, 1, 100, 45.00),
(2, 1, 6, 50, 280.00),
(3, 2, 2, 100, 85.00),
(4, 2, 4, 200, 18.00),
(5, 3, 3, 150, 35.00);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return`
--

CREATE TABLE `purchase_return` (
  `Purchase_Return_ID` int(11) NOT NULL,
  `PO_ID` int(11) NOT NULL,
  `Supplier_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Return_Date` date NOT NULL,
  `Status_ID` int(11) NOT NULL,
  `Reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_return`
--

INSERT INTO `purchase_return` (`Purchase_Return_ID`, `PO_ID`, `Supplier_ID`, `User_ID`, `Return_Date`, `Status_ID`, `Reason`) VALUES
(1, 1, 1, 2, '2026-09-06', 2, 'Damaged grocery items');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return_line`
--

CREATE TABLE `purchase_return_line` (
  `Purchase_Return_Line_ID` int(11) NOT NULL,
  `Purchase_Return_ID` int(11) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_return_line`
--

INSERT INTO `purchase_return_line` (`Purchase_Return_Line_ID`, `Purchase_Return_ID`, `Product_ID`, `Quantity`) VALUES
(1, 1, 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `receiving`
--

CREATE TABLE `receiving` (
  `ReceivingID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `ReceivedByUserID` int(11) NOT NULL,
  `ReceivingDate` date NOT NULL,
  `StatusID` int(11) NOT NULL,
  `PO_Reference` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `receiving`
--

INSERT INTO `receiving` (`ReceivingID`, `SupplierID`, `ReceivedByUserID`, `ReceivingDate`, `StatusID`, `PO_Reference`) VALUES
(1, 1, 2, '2026-09-03', 3, 'PO-0001'),
(2, 2, 2, '2026-09-04', 3, 'PO-0002');

-- --------------------------------------------------------

--
-- Table structure for table `receiving_line`
--

CREATE TABLE `receiving_line` (
  `ReceivingLineID` int(11) NOT NULL,
  `ReceivingID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `ReceivedQuantity` int(11) NOT NULL,
  `CostPrice` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `receiving_line`
--

INSERT INTO `receiving_line` (`ReceivingLineID`, `ReceivingID`, `ProductID`, `ReceivedQuantity`, `CostPrice`) VALUES
(1, 1, 1, 100, 45.00),
(2, 1, 6, 50, 280.00),
(3, 2, 2, 100, 85.00),
(4, 2, 4, 200, 18.00);

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `RoleID` int(11) NOT NULL,
  `RoleName` varchar(100) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`RoleID`, `RoleName`, `IsActive`) VALUES
(1, 'Admin', 1),
(2, 'Warehouse Staff', 1),
(3, 'Purchasing Staff', 1),
(4, 'Inventory Clerk', 1),
(5, 'Manager', 1);

-- --------------------------------------------------------

--
-- Table structure for table `shelf`
--

CREATE TABLE `shelf` (
  `ShelfID` int(11) NOT NULL,
  `AisleID` int(11) NOT NULL,
  `ShelfCode` varchar(50) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shelf`
--

INSERT INTO `shelf` (`ShelfID`, `AisleID`, `ShelfCode`, `IsActive`) VALUES
(1, 1, 'A1-S1', 1),
(2, 1, 'A1-S2', 1),
(3, 2, 'A2-S1', 1),
(4, 3, 'A3-S1', 1),
(5, 4, 'A4-S1', 1),
(6, 4, 'A4-S2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `StatusID` int(11) NOT NULL,
  `StatusName` varchar(100) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`StatusID`, `StatusName`, `IsActive`) VALUES
(1, 'Pending', 1),
(2, 'Approved', 1),
(3, 'Completed', 1),
(4, 'Cancelled', 1),
(5, 'Rejected', 1);

-- --------------------------------------------------------

--
-- Table structure for table `stock_release`
--

CREATE TABLE `stock_release` (
  `ReleaseID` int(11) NOT NULL,
  `RequestedByUserID` int(11) NOT NULL,
  `ReleasedByUserID` int(11) NOT NULL,
  `ReleaseDate` date NOT NULL,
  `Status_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_release`
--

INSERT INTO `stock_release` (`ReleaseID`, `RequestedByUserID`, `ReleasedByUserID`, `ReleaseDate`, `Status_ID`) VALUES
(1, 4, 2, '2026-09-08', 3),
(2, 4, 2, '2026-09-09', 3);

-- --------------------------------------------------------

--
-- Table structure for table `stock_release_line`
--

CREATE TABLE `stock_release_line` (
  `ReleaseLineID` int(11) NOT NULL,
  `ReleaseID` int(11) NOT NULL,
  `QuantityReleased` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_release_line`
--

INSERT INTO `stock_release_line` (`ReleaseLineID`, `ReleaseID`, `QuantityReleased`, `ProductID`) VALUES
(1, 1, 20, 3),
(2, 2, 30, 4);

-- --------------------------------------------------------

--
-- Table structure for table `stock_return`
--

CREATE TABLE `stock_return` (
  `Stock_Return_ID` int(11) NOT NULL,
  `User_ID` int(11) NOT NULL,
  `Return_Date` date NOT NULL,
  `Status_ID` int(11) NOT NULL,
  `Reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_return`
--

INSERT INTO `stock_return` (`Stock_Return_ID`, `User_ID`, `Return_Date`, `Status_ID`, `Reason`) VALUES
(1, 2, '2026-09-09', 2, 'Excess grocery items returned to warehouse');

-- --------------------------------------------------------

--
-- Table structure for table `stock_return_line`
--

CREATE TABLE `stock_return_line` (
  `Stock_Return_Line_ID` int(11) NOT NULL,
  `Stock_Return_ID` int(11) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_return_line`
--

INSERT INTO `stock_return_line` (`Stock_Return_Line_ID`, `Stock_Return_ID`, `Product_ID`, `Quantity`) VALUES
(1, 1, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `SupplierID` int(11) NOT NULL,
  `SupplierName` varchar(150) NOT NULL,
  `ContactPerson` varchar(150) DEFAULT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Email` varchar(150) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`SupplierID`, `SupplierName`, `ContactPerson`, `Phone`, `Email`, `Address`, `ProductID`, `IsActive`) VALUES
(1, 'FreshHarvest Produce Co.', 'Juan Dela Cruz', '09171234567', 'sales@freshharvest.com', 'Cebu City', 1, 1),
(2, 'Cebu Dairy Distributors', 'Maria Santos', '09281234567', 'orders@cebudairy.com', 'Mandaue City', 2, 1),
(3, 'Golden Canned Goods Trading', 'Pedro Reyes', '09391234567', 'info@goldencanned.com', 'Lapu-Lapu City', 3, 1),
(4, 'AquaPure Beverage Distributors', 'Ana Lim', '09451234567', 'orders@aquapure.com', 'Talisay City', 4, 1),
(5, 'SnackWorld Food Corp.', 'Carlos Uy', '09561234567', 'sales@snackworld.com', 'Cebu City', 5, 1),
(6, 'RiceDirect Trading', 'Mark Garcia', '09671234567', 'sales@ricedirect.com', 'Davao City', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserID` int(11) NOT NULL,
  `UserName` varchar(100) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `FirstName` varchar(100) NOT NULL,
  `LastName` varchar(100) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `RoleID` int(11) NOT NULL,
  `UserStatus` varchar(50) DEFAULT 'Active',
  `CreatedAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserID`, `UserName`, `Password`, `FirstName`, `LastName`, `Email`, `RoleID`, `UserStatus`, `CreatedAt`) VALUES
(1, 'admin', 'admin123', 'John', 'Doe', 'jdoe@company.com', 1, 'Active', '2026-09-10 22:06:14'),
(2, 'warehouse', 'warehouse123', 'Mary', 'Smith', 'msmith@company.com', 2, 'Active', '2026-09-10 22:06:14'),
(3, 'purchasing', 'purchase123', 'Robert', 'Cruz', 'rcruz@company.com', 3, 'Active', '2026-09-10 22:06:14'),
(4, 'inventory', 'inventory123', 'Anna', 'Garcia', 'agarcia@company.com', 4, 'Active', '2026-09-10 22:06:14'),
(5, 'manager', 'manager123', 'Paul', 'Tan', 'ptan@company.com', 5, 'Active', '2026-09-10 22:06:14'),
(6, 'Lian', '$2y$10$NDkGeCcDgdzjGrU.D.PJm.VOHF39salIRslRz5/j0Gsq8/LJ7ttu6', 'Lian Suzaine', 'Sultan', 'liansultan@gmail.com', 1, 'Active', '2026-09-10 23:02:02'),
(8, 'jenn', '$2y$10$0hDca1bfUwQjgPbKAc5Ya.WZvi52JW8g9AbOunu7YBKYwcYn.g7u2', 'Jennie', 'Redondo', 'jennieredondo@gmail.com', 1, 'Active', '2026-09-10 23:54:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aisle`
--
ALTER TABLE `aisle`
  ADD PRIMARY KEY (`AisleID`);

--
-- Indexes for table `auditlog`
--
ALTER TABLE `auditlog`
  ADD PRIMARY KEY (`AuditLogID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `bin`
--
ALTER TABLE `bin`
  ADD PRIMARY KEY (`BinID`),
  ADD KEY `ShelfID` (`ShelfID`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indexes for table `inventory_adjustment`
--
ALTER TABLE `inventory_adjustment`
  ADD PRIMARY KEY (`Adjustment_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `inventory_adjustment_line`
--
ALTER TABLE `inventory_adjustment_line`
  ADD PRIMARY KEY (`Adjustment_Line_ID`),
  ADD KEY `Adjustment_ID` (`Adjustment_ID`),
  ADD KEY `Product_ID` (`Product_ID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`ProductID`),
  ADD UNIQUE KEY `SKU` (`SKU`),
  ADD UNIQUE KEY `Barcode` (`Barcode`),
  ADD KEY `BinID` (`BinID`),
  ADD KEY `CategoryID` (`CategoryID`);

--
-- Indexes for table `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD PRIMARY KEY (`PO_ID`),
  ADD KEY `Supplier_ID` (`Supplier_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `purchase_order_line`
--
ALTER TABLE `purchase_order_line`
  ADD PRIMARY KEY (`PO_Line_ID`),
  ADD KEY `PO_ID` (`PO_ID`),
  ADD KEY `Product_ID` (`Product_ID`);

--
-- Indexes for table `purchase_return`
--
ALTER TABLE `purchase_return`
  ADD PRIMARY KEY (`Purchase_Return_ID`),
  ADD KEY `PO_ID` (`PO_ID`),
  ADD KEY `Supplier_ID` (`Supplier_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `purchase_return_line`
--
ALTER TABLE `purchase_return_line`
  ADD PRIMARY KEY (`Purchase_Return_Line_ID`),
  ADD KEY `Purchase_Return_ID` (`Purchase_Return_ID`),
  ADD KEY `Product_ID` (`Product_ID`);

--
-- Indexes for table `receiving`
--
ALTER TABLE `receiving`
  ADD PRIMARY KEY (`ReceivingID`),
  ADD KEY `SupplierID` (`SupplierID`),
  ADD KEY `ReceivedByUserID` (`ReceivedByUserID`),
  ADD KEY `StatusID` (`StatusID`);

--
-- Indexes for table `receiving_line`
--
ALTER TABLE `receiving_line`
  ADD PRIMARY KEY (`ReceivingLineID`),
  ADD KEY `ReceivingID` (`ReceivingID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`RoleID`);

--
-- Indexes for table `shelf`
--
ALTER TABLE `shelf`
  ADD PRIMARY KEY (`ShelfID`),
  ADD KEY `AisleID` (`AisleID`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`StatusID`);

--
-- Indexes for table `stock_release`
--
ALTER TABLE `stock_release`
  ADD PRIMARY KEY (`ReleaseID`),
  ADD KEY `RequestedByUserID` (`RequestedByUserID`),
  ADD KEY `ReleasedByUserID` (`ReleasedByUserID`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `stock_release_line`
--
ALTER TABLE `stock_release_line`
  ADD PRIMARY KEY (`ReleaseLineID`),
  ADD KEY `ReleaseID` (`ReleaseID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `stock_return`
--
ALTER TABLE `stock_return`
  ADD PRIMARY KEY (`Stock_Return_ID`),
  ADD KEY `User_ID` (`User_ID`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `stock_return_line`
--
ALTER TABLE `stock_return_line`
  ADD PRIMARY KEY (`Stock_Return_Line_ID`),
  ADD KEY `Stock_Return_ID` (`Stock_Return_ID`),
  ADD KEY `Product_ID` (`Product_ID`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`SupplierID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `UserName` (`UserName`),
  ADD KEY `RoleID` (`RoleID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aisle`
--
ALTER TABLE `aisle`
  MODIFY `AisleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `auditlog`
--
ALTER TABLE `auditlog`
  MODIFY `AuditLogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `bin`
--
ALTER TABLE `bin`
  MODIFY `BinID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_adjustment`
--
ALTER TABLE `inventory_adjustment`
  MODIFY `Adjustment_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `inventory_adjustment_line`
--
ALTER TABLE `inventory_adjustment_line`
  MODIFY `Adjustment_Line_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `purchase_order`
--
ALTER TABLE `purchase_order`
  MODIFY `PO_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `purchase_order_line`
--
ALTER TABLE `purchase_order_line`
  MODIFY `PO_Line_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `purchase_return`
--
ALTER TABLE `purchase_return`
  MODIFY `Purchase_Return_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `purchase_return_line`
--
ALTER TABLE `purchase_return_line`
  MODIFY `Purchase_Return_Line_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `receiving`
--
ALTER TABLE `receiving`
  MODIFY `ReceivingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `receiving_line`
--
ALTER TABLE `receiving_line`
  MODIFY `ReceivingLineID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `RoleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `shelf`
--
ALTER TABLE `shelf`
  MODIFY `ShelfID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `StatusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `stock_release`
--
ALTER TABLE `stock_release`
  MODIFY `ReleaseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `stock_release_line`
--
ALTER TABLE `stock_release_line`
  MODIFY `ReleaseLineID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `stock_return`
--
ALTER TABLE `stock_return`
  MODIFY `Stock_Return_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stock_return_line`
--
ALTER TABLE `stock_return_line`
  MODIFY `Stock_Return_Line_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `SupplierID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auditlog`
--
ALTER TABLE `auditlog`
  ADD CONSTRAINT `auditlog_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`);

--
-- Constraints for table `bin`
--
ALTER TABLE `bin`
  ADD CONSTRAINT `bin_ibfk_1` FOREIGN KEY (`ShelfID`) REFERENCES `shelf` (`ShelfID`);

--
-- Constraints for table `inventory_adjustment`
--
ALTER TABLE `inventory_adjustment`
  ADD CONSTRAINT `inventory_adjustment_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `inventory_adjustment_ibfk_2` FOREIGN KEY (`Status_ID`) REFERENCES `status` (`StatusID`);

--
-- Constraints for table `inventory_adjustment_line`
--
ALTER TABLE `inventory_adjustment_line`
  ADD CONSTRAINT `inventory_adjustment_line_ibfk_1` FOREIGN KEY (`Adjustment_ID`) REFERENCES `inventory_adjustment` (`Adjustment_ID`),
  ADD CONSTRAINT `inventory_adjustment_line_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`BinID`) REFERENCES `bin` (`BinID`),
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`);

--
-- Constraints for table `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD CONSTRAINT `purchase_order_ibfk_1` FOREIGN KEY (`Supplier_ID`) REFERENCES `supplier` (`SupplierID`),
  ADD CONSTRAINT `purchase_order_ibfk_2` FOREIGN KEY (`User_ID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `purchase_order_ibfk_3` FOREIGN KEY (`Status_ID`) REFERENCES `status` (`StatusID`);

--
-- Constraints for table `purchase_order_line`
--
ALTER TABLE `purchase_order_line`
  ADD CONSTRAINT `purchase_order_line_ibfk_1` FOREIGN KEY (`PO_ID`) REFERENCES `purchase_order` (`PO_ID`),
  ADD CONSTRAINT `purchase_order_line_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `purchase_return`
--
ALTER TABLE `purchase_return`
  ADD CONSTRAINT `purchase_return_ibfk_1` FOREIGN KEY (`PO_ID`) REFERENCES `purchase_order` (`PO_ID`),
  ADD CONSTRAINT `purchase_return_ibfk_2` FOREIGN KEY (`Supplier_ID`) REFERENCES `supplier` (`SupplierID`),
  ADD CONSTRAINT `purchase_return_ibfk_3` FOREIGN KEY (`User_ID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `purchase_return_ibfk_4` FOREIGN KEY (`Status_ID`) REFERENCES `status` (`StatusID`);

--
-- Constraints for table `purchase_return_line`
--
ALTER TABLE `purchase_return_line`
  ADD CONSTRAINT `purchase_return_line_ibfk_1` FOREIGN KEY (`Purchase_Return_ID`) REFERENCES `purchase_return` (`Purchase_Return_ID`),
  ADD CONSTRAINT `purchase_return_line_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `receiving`
--
ALTER TABLE `receiving`
  ADD CONSTRAINT `receiving_ibfk_1` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`),
  ADD CONSTRAINT `receiving_ibfk_2` FOREIGN KEY (`ReceivedByUserID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `receiving_ibfk_3` FOREIGN KEY (`StatusID`) REFERENCES `status` (`StatusID`);

--
-- Constraints for table `receiving_line`
--
ALTER TABLE `receiving_line`
  ADD CONSTRAINT `receiving_line_ibfk_1` FOREIGN KEY (`ReceivingID`) REFERENCES `receiving` (`ReceivingID`),
  ADD CONSTRAINT `receiving_line_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `shelf`
--
ALTER TABLE `shelf`
  ADD CONSTRAINT `shelf_ibfk_1` FOREIGN KEY (`AisleID`) REFERENCES `aisle` (`AisleID`);

--
-- Constraints for table `stock_release`
--
ALTER TABLE `stock_release`
  ADD CONSTRAINT `stock_release_ibfk_1` FOREIGN KEY (`RequestedByUserID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `stock_release_ibfk_2` FOREIGN KEY (`ReleasedByUserID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `stock_release_ibfk_3` FOREIGN KEY (`Status_ID`) REFERENCES `status` (`StatusID`);

--
-- Constraints for table `stock_release_line`
--
ALTER TABLE `stock_release_line`
  ADD CONSTRAINT `stock_release_line_ibfk_1` FOREIGN KEY (`ReleaseID`) REFERENCES `stock_release` (`ReleaseID`),
  ADD CONSTRAINT `stock_release_line_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `stock_return`
--
ALTER TABLE `stock_return`
  ADD CONSTRAINT `stock_return_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `stock_return_ibfk_2` FOREIGN KEY (`Status_ID`) REFERENCES `status` (`StatusID`);

--
-- Constraints for table `stock_return_line`
--
ALTER TABLE `stock_return_line`
  ADD CONSTRAINT `stock_return_line_ibfk_1` FOREIGN KEY (`Stock_Return_ID`) REFERENCES `stock_return` (`Stock_Return_ID`),
  ADD CONSTRAINT `stock_return_line_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `supplier`
--
ALTER TABLE `supplier`
  ADD CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`RoleID`) REFERENCES `role` (`RoleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
