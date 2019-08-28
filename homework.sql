---0. 庫名: iii
create database iii;

use iii;

---1. 客戶資料表：id(int primary,autoincrement),姓名,電話(uni),email,address
create table Customers (CustomerID int primary key auto_increment,
Cname varchar(30),Ctel varchar(24) unique key,Cemail varchar(30),Caddress varchar(60));

---2. 供應商: id(...),名稱,電話(uni),地址
create table Suppliers(SupplierID int primary key auto_increment,
Sname varchar(30),Stel varchar(24) unique key,Saddress varchar(60));

---3. 商品表: id(...),編號(uni),名稱,建議售價,供應商(f)
create table Products(ProductID int primary key auto_increment,
Pnum int unique key,Pname varchar(40),Unitprice decimal(19,4),SupplierID int
,foreign key(SupplierID) references suppliers (SupplierID));

---4. 訂單: id(...),編號(uni),客戶(f)
create table Orders(OrderID int primary key auto_increment,Onum int unique key,
CustomerID int,foreign key(CustomerID) references Customers (CustomerID));

---5. 訂單細項: id(...),編號(f),商品(f),實際單價,數量
create table `Order details`(odID int primary key auto_increment,
ODnum int,ProductID int,UnitPrice decimal(19,4),quantity smallint(6),
foreign key (ODnum) references Orders (Onum),
foreign key (ProductID) references Products (ProductID));

---6. 客戶: 新增,刪除,修改

--新增
\d |
create procedure insertC(in name varchar(30),in tel varchar(24),in email varchar(30),in address varchar(60))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. ctel duplicate' as 'Error Message!';
    end;
    insert into customers (cname,ctel,cemail,caddress) values (name,tel,email,address);
    
end |
\d ;

--刪除
\d |
create procedure deleteC(in id int)
begin    
    delete from customers where CustomerID = id;
    
end |
\d ; 

--修改
\d |
create procedure updateC(in id int,in name varchar(30),in tel varchar(24),in email varchar(30),in address varchar(60))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. ctel duplicate' as 'Error Message!';
    end;
    update customers set cname=name ,ctel=tel ,cemail =email,caddress=address where customerID=id;
    
end |
\d ; 

---查詢: 電話, 姓名 => 關鍵字, 若無 => 全部

--查詢: 電話  若無('') => 全部
\d |
create procedure selectCtel (in tel varchar(24))
begin
    
    set @kw1 = concat('%',tel,'%') COLLATE utf8_unicode_ci;
    
    select * from customers where ctel like @kw1;
    
end |
\d ;

--查詢: 姓名  若無('') => 全部

\d |
create procedure selectCname (in name varchar(30))
begin
    
    set @kw1 = concat('%',name,'%') COLLATE utf8_unicode_ci;
    
    select * from customers where cname like @kw1;
    
end |
\d ;



---7. 供應商: 新增,刪除,修改

--新增
\d |
create procedure insertS(in name varchar(30),in tel varchar(24),in address varchar(60))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. stel duplicate' as 'Error Message!';
    end;
    insert into Suppliers (sname,stel,saddress) values (name,tel,address);
    
end |
\d ;

--刪除
\d |
create procedure deleteS(in id int)
begin
  delete from Suppliers where SupplierID=id;
  
end |
\d ;

--修改
\d |
create procedure updateS(in id int,in name varchar(30),in tel varchar(24),in address varchar(60))
begin
declare exit handler for sqlstate '23000'
    begin
        select 'Error. ctel duplicate' as 'Error Message!';
    end;
update Suppliers set sname=name,stel=tel,saddress=address where SupplierID=id;

end |
\d ; 

---查詢: 名稱,電話 => 關鍵字, 若無 => 全部


--查詢: 名稱  若無('') => 全部
\d |
create procedure selectSname(in name varchar(24))
begin
    
    set @kw1 = concat('%',name,'%') COLLATE utf8_unicode_ci;
    
    select * from suppliers where sname like @kw1;
    
end |
\d ;

--查詢: 電話  若無('') => 全部
\d |
create procedure selectStel(in tel varchar(24))
begin
    
    set @kw1 = concat('%',tel,'%') COLLATE utf8_unicode_ci;
    
    select * from suppliers where stel like @kw1;
    
end |
\d ;


---8. 商品: 新增,刪除,修改 

--新增
\d |
create procedure insertP(in num int,in name varchar(40),in price decimal(19,4),in sid int)
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. Pnum duplicate or No such SupplierID' as 'Error Message!';
    end;
    set @price=price;
    insert into Products (Pnum,Pname,Unitprice,SupplierID) values (num,name,price,sid);
    
end |
\d ;  

--刪除
\d |
create procedure deleteP(in id int)
begin   
    delete from products where productid=id;
    
end|
\d ;

--修改
\d |
create procedure updateP(in id int,in num int,in name varchar(40),in price decimal(19,4),in sid int)
begin
declare exit handler for sqlstate '23000'
    begin
        select 'Error. Pnum duplicate or No such SupplierID' as 'Error Message!';
    end;
    
    update Products set Pnum=num,Pname=name,Unitprice=price,SupplierID=sid where productid=id;
    
end |
\d ; 


---查詢: 名稱 => 關鍵字, 若無 => 全部
\d |
create procedure selectPname(in name varchar(30))
begin
    
    set @kw1 = concat('%',name,'%') COLLATE utf8_unicode_ci;
    
    select * from products where Pname like @kw1;
    
end |
\d ;



---9. 訂單: 新增,刪除 => 包含訂單細項的處理

--新增

create procedure insertO(in num int,in customerid int,in productid int,in uprice decimal(19,4),in quantity smallint(6))
begin
    declare continue handler for sqlstate '23000'
    begin
        select 'Error. Onum duplicate or Foreign error' as 'Error Message!';
    end;
    insert into orders (onum,customerid) values (num,customerid);
    insert into `order details` (ODnum,ProductID,UnitPrice,quantity) values (num,productid,uprice,quantity);
    
end |
\d ;  

-- 刪除
\d | 
create procedure deleteO(in num int)
begin   
    delete from `order details` where ODnum=num;
    delete from orders where onum=num;
    
end|
\d ;

---10.訂單明細: 新增,刪除,修改(只能修改數量及實際單價)

--新增
\d |
create procedure insertOD(in num int,in productid int,in uprice decimal(19,4),in quantity smallint(6))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. Foreign error' as 'Error Message!';
    end;
    insert into `order details` (ODnum,ProductID,UnitPrice,quantity) values (num,productid,uprice,quantity);
    
end |
\d;

--刪除
\d |
create procedure deleteOD(in id int)
begin
    delete from `order details` where odID=id;
    
end |
\d ;

--修改
\d |
create procedure updateOD(in id int,uprice decimal(19,4),in quantity smallint(6))
begin
declare exit handler for sqlstate '23000'
    begin
        select 'Error. Foreign error' as 'Error Message!';
    end;
    set @quantity=quantity;
    update `order details` set unitprice=uprice,quantity=@quantity where odID=id;
    
end |
\d ; 

--11. 綜合查詢:
--a. 指定客戶查詢訂單,含訂單明細
\d |
create procedure a(in name varchar(30))
begin
set @kw = concat('%',name,'%');
select c.cname, o.*,od.*
from orders o
join customers c using(customerid)
join `order details` od on (o.onum = od.odnum)
where c.cname like @kw ;
end |
\d ;


--b. 指定客戶查詢訂單總金額
\d |
create procedure b(in name varchar(30))
begin
set @kw = concat('%',name,'%');
select c.cname,floor(sum(od.unitprice*od.quantity)) as total
from orders o
join customers c using(customerid)
join `order details` od on (o.onum = od.odnum)
where c.cname like @kw 
group by c.cname;
end |
\d ;


--c. 指定商品查詢訂單中的客戶, 例如: 商品P001的客戶有哪些,買幾個
\d |
create procedure c (in id int)
begin
select p.pname,c.cname,SUM(od.quantity) quantity
from orders o
join `order details` od on (o.onum = od.odnum)
join customers c using(customerid)
join products p using(productid)
where p.pnum= id
group by c.cname;
end |
\d ;


--d. 指定供應商,查詢訂單中的商品清單
\d |
create procedure d(in name varchar(24))
begin
set @kw = concat('%',name,'%');
select s.supplierid,s.sname,p.productid,p.pname,SUM(od.quantity) quantity
from suppliers s
join products p using(supplierid)
join `order details` od using(productid)
where s.sname like @kw
group by p.pname;
end |
\d ;












---資料庫資料
--客戶
INSERT INTO `customers` (`CustomerID`, `Cname`, `Ctel`, `Cemail`, `Caddress`) VALUES
(1, 'Alfreds Futterkiste', '030-0074321', 'Berlin', 'Obere Str. 57'),
(9, 'Berglunds snabbkop', '0921-12 34 65', 'Lulea', 'Berguvsvagen  8'),
(10, 'Bon appaa', '91.24.45.40', 'Marseille', '12, rue des Bouchers'),
(11, 'B\'s Beverages', '(171) 555-1212', 'London', 'Fauntleroy Circus'),
(12, 'Comercio Mineiro', '(11) 555-7647', 'Sao Paulo', 'Av. dos Lusiadas, 23'),
(13, 'Bottom-Dollar Markets', '(604) 555-4729', 'Tsawass', '23 Tsawassen Blvd.');


--供應商

INSERT INTO `suppliers` (`SupplierID`, `Sname`, `Stel`, `Saddress`) VALUES
(1, 'Exotic Liquids', '(171) 555-2222', '49 Gilbert St.'),
(3, 'mimi', '(171) 555333', 'changua'),
(6, 'Pavlova, Ltd.', '(03) 444-2343', '74 Rose St. Moonie Ponds'),
(7, 'PB Knackebrod AB', '031-987 65 43', 'Kaloadagatan 13'),
(8, 'Norske Meierier', '(0)2-953010', 'Hatlevegen 5'),
(9, 'Bigfoot Breweries', '(503) 555-9931', '3400 - 8th Avenue Suite 210');

--商品
INSERT INTO `products` (`ProductID`, `Pnum`, `Pname`, `Unitprice`, `SupplierID`) VALUES
(1, 1, 'cookie', '60.0000', 3),
(5, 3, 'mumi', '45.0000', 1),
(6, 4, 'mask', '25.0000', 3),
(7, 5, 'cosmetic', '100.0000', 3),
(8, 6, 'aaa', '50.0000', 6),
(9, 7, 'bbb', '30.0000', 1);



--訂單
INSERT INTO `orders` (`OrderID`, `Onum`, `CustomerID`) VALUES
(1, 1, 1),
(3, 2, 1),
(6, 4, 10),
(7, 5, 10),
(8, 6, 11),
(9, 7, 12),
(10, 8, 13);


--訂單細項
INSERT INTO `order details` (`odID`, `ODnum`, `ProductID`, `UnitPrice`, `quantity`) VALUES
(1, 1, 5, '50.0000', 100),
(2, 2, 6, '30.0000', 60),
(4, 4, 1, '70.0000', 200),
(5, 5, 8, '70.0000', 30),
(6, 4, 7, '130.0000', 40),
(8, 2, 8, '90.0000', 15),
(9, 2, 8, '65.0000', 60),
(10, 1, 1, '65.0000', 80),
(11, 6, 5, '45.0000', 110),
(12, 6, 6, '33.0000', 30),
(13, 7, 6, '35.0000', 50),
(14, 8, 6, '28.0000', 100),
(15, 1, 1, '50.0000', 100),
(18, 1, 1, '60.0000', 50);