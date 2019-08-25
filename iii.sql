-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2019-08-25 17:28:46
-- 伺服器版本： 10.3.16-MariaDB
-- PHP 版本： 7.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `iii`
--
CREATE DATABASE IF NOT EXISTS `iii` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `iii`;

DELIMITER $$
--
-- 程序
--
DROP PROCEDURE IF EXISTS `a`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `a` (IN `id` INT)  begin select o.orderid,o.onum,o.customerID,od.odid,od.odnum,od.productid,od.unitprice,od.quantity from orders o join customers c using(customerID) join `order details` od on (o.onum = od.odnum) where c.customerID=id; end$$

DROP PROCEDURE IF EXISTS `b`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `b` (IN `id` INT)  begin select c.customerID,floor(sum(od.unitprice*od.quantity)) as total from orders o join customers c using(customerID) join `order details` od on (o.onum = od.odnum) where c.customerID=id;  end$$

DROP PROCEDURE IF EXISTS `deleteC`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteC` (IN `id` INT)  BEGIN        
 delete from customers where CustomerID = id;
 select 'delete Success.';
end$$

DROP PROCEDURE IF EXISTS `deleteO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteO` (IN `num` INT)  begin     delete from `order details` where ODnum=num;     delete from orders where onum=num;     select 'delete Success.'; end$$

DROP PROCEDURE IF EXISTS `deleteOD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOD` (IN `id` INT)  begin     delete from `order details` where odID=id;     select 'delete Success.'; end$$

DROP PROCEDURE IF EXISTS `deleteP`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteP` (IN `id` INT)  begin     delete from products where productid=id;     select 'delete Success.'; end$$

DROP PROCEDURE IF EXISTS `deleteS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteS` (IN `id` INT)  begin   delete from Suppliers where SupplierID=id;   select 'delete Success.'; end$$

DROP PROCEDURE IF EXISTS `insertC`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertC` (IN `name` VARCHAR(30), IN `tel` VARCHAR(24), IN `email` VARCHAR(30), IN `address` VARCHAR(60))  begin     declare exit handler for sqlstate '23000'     begin         select 'Error. ctel duplicate';     end;     insert into customers (cname,ctel,cemail,caddress) values (name,tel,email,address);     select 'insert Success.'; end$$

DROP PROCEDURE IF EXISTS `insertO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertO` (IN `num` INT, IN `customerid` INT, IN `productid` INT, IN `uprice` DECIMAL(19,4), IN `quantity` SMALLINT(6))  begin     declare exit handler for sqlstate '23000'     begin         select 'Error. Onum duplicate or Foreign error';     end;     insert into orders (onum,customerid) values (num,customerid);     insert into `order details` (ODnum,ProductID,UnitPrice,quantity) values (num,productid,uprice,quantity);     select 'insert Success.'; end$$

DROP PROCEDURE IF EXISTS `insertOD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertOD` (IN `num` INT, IN `productid` INT, IN `uprice` DECIMAL(19,4), IN `quantity` SMALLINT(6))  begin     declare exit handler for sqlstate '23000'     begin         select 'Error. Foreign error';     end;     insert into `order details` (ODnum,ProductID,UnitPrice,quantity) values (num,productid,uprice,quantity);     select 'insert Success.'; end$$

DROP PROCEDURE IF EXISTS `insertP`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertP` (IN `num` INT, IN `name` VARCHAR(40), IN `price` DECIMAL(19,4), IN `sid` INT)  begin     declare exit handler for sqlstate '23000'     begin         select 'Error. Pnum duplicate or No such SupplierID';     end;     insert into Products (Pnum,Pname,Unitprice,SupplierID) values (num,name,price,sid);     select 'insert Success.'; end$$

DROP PROCEDURE IF EXISTS `insertS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertS` (IN `name` VARCHAR(30), IN `tel` VARCHAR(24), IN `address` VARCHAR(60))  begin     declare exit handler for sqlstate '23000'     begin         select 'Error. stel duplicate';     end;     insert into Suppliers (sname,stel,saddress) values (name,tel,address);     select 'insert Success.'; end$$

DROP PROCEDURE IF EXISTS `selectCtel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `selectCtel` (IN `tel` VARCHAR(24))  begin         set @kw1 = concat('%',tel,'%') COLLATE utf8_unicode_ci;      select * from customers where ctel like @kw1;      end$$

DROP PROCEDURE IF EXISTS `updateC`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateC` (IN `id` INT, IN `name` VARCHAR(30), IN `tel` VARCHAR(24), IN `email` VARCHAR(30), IN `address` VARCHAR(60))  begin     declare exit handler for sqlstate '23000'     begin         select 'Error. ctel duplicate';     end;     update customers set cname=name ,ctel=tel ,cemail =email,caddress=address where customerID=id; 
select 'update Success.';
end$$

DROP PROCEDURE IF EXISTS `updateOD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOD` (IN `id` INT, `uprice` DECIMAL(19,4), IN `quantity` SMALLINT(6))  begin declare exit handler for sqlstate '23000'     begin         select 'Error. Foreign error';     end;     set @quantity=quantity;     update `order details` set unitprice=uprice,quantity=@quantity where odID=id;     select 'update Success.'; end$$

DROP PROCEDURE IF EXISTS `updateP`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateP` (IN `id` INT, IN `num` INT, IN `name` VARCHAR(40), IN `price` DECIMAL(19,4), IN `sid` INT)  begin declare exit handler for sqlstate '23000'     begin         select 'Error. Pnum duplicate or No such SupplierID';     end;         update Products set Pnum=num,Pname=name,Unitprice=price,SupplierID=sid where productid=id;     select 'update Success.'; end$$

DROP PROCEDURE IF EXISTS `updateS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateS` (IN `id` INT, IN `name` VARCHAR(30), IN `tel` VARCHAR(24), IN `address` VARCHAR(60))  begin declare exit handler for sqlstate '23000'     begin         select 'Error. ctel duplicate';     end; update Suppliers set sname=name,stel=tel,saddress=address where SupplierID=id; select 'update Success.'; end$$

--
-- 函式
--
DROP FUNCTION IF EXISTS `selectCtelF`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `selectCtelF` (`tel` VARCHAR(24)) RETURNS TEXT CHARSET utf8 COLLATE utf8_unicode_ci begin     declare result varchar(30);     select * from customers into result;     if tel is not null then     call selectCtel(tel);      else     return result;     end if; end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `CustomerID` int(11) NOT NULL,
  `Cname` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Ctel` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Cemail` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Caddress` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 傾印資料表的資料 `customers`
--

INSERT INTO `customers` (`CustomerID`, `Cname`, `Ctel`, `Cemail`, `Caddress`) VALUES
(1, 'Alfreds Futterkiste', '030-0074321', 'Berlin', 'Obere Str. 57'),
(9, 'Berglunds snabbkop', '0921-12 34 65', 'Lulea', 'Berguvsvagen  8'),
(10, 'Bon appaa', '91.24.45.40', 'Marseille', '12, rue des Bouchers'),
(11, 'B\'s Beverages', '(171) 555-1212', 'London', 'Fauntleroy Circus'),
(12, 'Comercio Mineiro', '(11) 555-7647', 'Sao Paulo', 'Av. dos Lusiadas, 23'),
(13, 'Bottom-Dollar Markets', '(604) 555-4729', 'Tsawass', '23 Tsawassen Blvd.');

-- --------------------------------------------------------

--
-- 資料表結構 `order details`
--

DROP TABLE IF EXISTS `order details`;
CREATE TABLE `order details` (
  `odID` int(11) NOT NULL,
  `ODnum` int(11) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `UnitPrice` decimal(19,4) DEFAULT NULL,
  `quantity` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 傾印資料表的資料 `order details`
--

INSERT INTO `order details` (`odID`, `ODnum`, `ProductID`, `UnitPrice`, `quantity`) VALUES
(1, 1, 5, '50.0000', 100),
(2, 2, 6, '30.0000', 60),
(4, 4, 1, '70.0000', 200),
(5, 5, 8, '70.0000', 30),
(6, 4, 7, '130.0000', 40),
(8, 2, 8, '90.0000', 15),
(9, 2, 8, '65.0000', 60);

-- --------------------------------------------------------

--
-- 資料表結構 `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL,
  `Onum` int(11) DEFAULT NULL,
  `CustomerID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 傾印資料表的資料 `orders`
--

INSERT INTO `orders` (`OrderID`, `Onum`, `CustomerID`) VALUES
(1, 1, 1),
(3, 2, 1),
(6, 4, 10),
(7, 5, 10);

-- --------------------------------------------------------

--
-- 資料表結構 `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `ProductID` int(11) NOT NULL,
  `Pnum` int(11) DEFAULT NULL,
  `Pname` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Unitprice` decimal(19,4) DEFAULT NULL,
  `SupplierID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 傾印資料表的資料 `products`
--

INSERT INTO `products` (`ProductID`, `Pnum`, `Pname`, `Unitprice`, `SupplierID`) VALUES
(1, 1, 'cookie', '60.0000', 3),
(5, 3, 'mumi', '45.0000', 1),
(6, 4, 'mask', '25.0000', 3),
(7, 5, 'cosmetic', '100.0000', 3),
(8, 6, 'aaa', '50.0000', 6),
(9, 7, 'bbb', '30.0000', 1);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `selectc`
-- (請參考以下實際畫面)
--
DROP VIEW IF EXISTS `selectc`;
CREATE TABLE `selectc` (
`CustomerID` int(11)
,`Cname` varchar(30)
,`Ctel` varchar(24)
,`Cemail` varchar(30)
,`Caddress` varchar(60)
);

-- --------------------------------------------------------

--
-- 資料表結構 `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `SupplierID` int(11) NOT NULL,
  `Sname` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Stel` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Saddress` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 傾印資料表的資料 `suppliers`
--

INSERT INTO `suppliers` (`SupplierID`, `Sname`, `Stel`, `Saddress`) VALUES
(1, 'Exotic Liquids', '(171) 555-2222', '49 Gilbert St.'),
(3, 'mimi', '(171) 555333', 'changua'),
(6, 'Pavlova, Ltd.', '(03) 444-2343', '74 Rose St. Moonie Ponds'),
(7, 'PB Knackebrod AB', '031-987 65 43', 'Kaloadagatan 13'),
(8, 'Norske Meierier', '(0)2-953010', 'Hatlevegen 5'),
(9, 'Bigfoot Breweries', '(503) 555-9931', '3400 - 8th Avenue Suite 210');

-- --------------------------------------------------------

--
-- 檢視表結構 `selectc`
--
DROP TABLE IF EXISTS `selectc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `selectc`  AS  select `customers`.`CustomerID` AS `CustomerID`,`customers`.`Cname` AS `Cname`,`customers`.`Ctel` AS `Ctel`,`customers`.`Cemail` AS `Cemail`,`customers`.`Caddress` AS `Caddress` from `customers` ;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`),
  ADD UNIQUE KEY `Ctel` (`Ctel`);

--
-- 資料表索引 `order details`
--
ALTER TABLE `order details`
  ADD PRIMARY KEY (`odID`),
  ADD KEY `ODnum` (`ODnum`),
  ADD KEY `ProductID` (`ProductID`);

--
-- 資料表索引 `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`),
  ADD UNIQUE KEY `Onum` (`Onum`),
  ADD KEY `CustomerID` (`CustomerID`);

--
-- 資料表索引 `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`ProductID`),
  ADD UNIQUE KEY `Pnum` (`Pnum`),
  ADD KEY `SupplierID` (`SupplierID`);

--
-- 資料表索引 `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`SupplierID`),
  ADD UNIQUE KEY `Stel` (`Stel`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `order details`
--
ALTER TABLE `order details`
  MODIFY `odID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `products`
--
ALTER TABLE `products`
  MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `SupplierID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `order details`
--
ALTER TABLE `order details`
  ADD CONSTRAINT `order details_ibfk_1` FOREIGN KEY (`ODnum`) REFERENCES `orders` (`Onum`),
  ADD CONSTRAINT `order details_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`);

--
-- 資料表的限制式 `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`);

--
-- 資料表的限制式 `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
