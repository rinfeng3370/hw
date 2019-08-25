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
        select 'Error. ctel duplicate';
    end;
    insert into customers (cname,ctel,cemail,caddress) values (name,tel,email,address);
    select 'insert Success.';
end |
\d ;

--刪除
\d |
create procedure deleteC(in id int)
begin    
    delete from customers where CustomerID = id;
    select 'delete Success.';
end |
\d ; 

--修改
\d |
create procedure updateC(in id int,in name varchar(30),in tel varchar(24),in email varchar(30),in address varchar(60))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. ctel duplicate';
    end;
    update customers set cname=name ,ctel=tel ,cemail =email,caddress=address where customerID=id;
    select 'update Success.';
end |
\d ; 

---查詢: 電話, 姓名 => 關鍵字, 若無 => 全部

查詢: 電話
\d |
create procedure selectCtel (in tel varchar(24))
begin
    
    set @kw1 = concat('%',tel,'%') COLLATE utf8_unicode_ci;
    
    select * from customers where ctel like @kw1;
    
end |
\d ;




---7. 供應商: 新增,刪除,修改

--新增
\d |
create procedure insertS(in name varchar(30),in tel varchar(24),in address varchar(60))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. stel duplicate';
    end;
    insert into Suppliers (sname,stel,saddress) values (name,tel,address);
    select 'insert Success.';
end |
\d ;

--刪除
\d |
create procedure deleteS(in id int)
begin
  delete from Suppliers where SupplierID=id;
  select 'delete Success.';
end |
\d ;

--修改
\d |
create procedure updateS(in id int,in name varchar(30),in tel varchar(24),in address varchar(60))
begin
declare exit handler for sqlstate '23000'
    begin
        select 'Error. ctel duplicate';
    end;
update Suppliers set sname=name,stel=tel,saddress=address where SupplierID=id;
select 'update Success.';
end |
\d ; 

---查詢: 名稱,電話 => 關鍵字, 若無 => 全部

---8. 商品: 新增,刪除,修改 

--新增
\d |
create procedure insertP(in num int,in name varchar(40),in price decimal(19,4),in sid int)
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. Pnum duplicate or No such SupplierID';
    end;
    set @price=price;
    insert into Products (Pnum,Pname,Unitprice,SupplierID) values (num,name,price,sid);
    select 'insert Success.';
end |
\d ;  

--刪除
\d |
create procedure deleteP(in id int)
begin   
    delete from products where productid=id;
    select 'delete Success.';
end|
\d ;

--修改
\d |
create procedure updateP(in id int,in num int,in name varchar(40),in price decimal(19,4),in sid int)
begin
declare exit handler for sqlstate '23000'
    begin
        select 'Error. Pnum duplicate or No such SupplierID';
    end;
    
    update Products set Pnum=num,Pname=name,Unitprice=price,SupplierID=sid where productid=id;
    select 'update Success.';
end |
\d ; 


---查詢: 名稱 => 關鍵字, 若無 => 全部


---9. 訂單: 新增,刪除 => 包含訂單細項的處理

--新增
\d |
create procedure insertO(in num int,in customerid int,in productid int,in uprice decimal(19,4),in quantity smallint(6))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. Onum duplicate or Foreign error';
    end;
    insert into orders (onum,customerid) values (num,customerid);
    insert into `order details` (ODnum,ProductID,UnitPrice,quantity) values (num,productid,uprice,quantity);
    select 'insert Success.';
end |
\d ;  

-- 刪除
\d | 
create procedure deleteO(in num int)
begin   
    delete from `order details` where ODnum=num;
    delete from orders where onum=num;
    select 'delete Success.';
end|
\d ;

---10.訂單明細: 新增,刪除,修改(只能修改數量及實際單價)

--新增
\d |
create procedure insertOD(in num int,in productid int,in uprice decimal(19,4),in quantity smallint(6))
begin
    declare exit handler for sqlstate '23000'
    begin
        select 'Error. Foreign error';
    end;
    insert into `order details` (ODnum,ProductID,UnitPrice,quantity) values (num,productid,uprice,quantity);
    select 'insert Success.';
end |
\d;

--刪除
\d |
create procedure deleteOD(in id int)
begin
    delete from `order details` where odID=id;
    select 'delete Success.';
end |
\d ;

--修改
\d |
create procedure updateOD(in id int,uprice decimal(19,4),in quantity smallint(6))
begin
declare exit handler for sqlstate '23000'
    begin
        select 'Error. Foreign error';
    end;
    set @quantity=quantity;
    update `order details` set unitprice=uprice,quantity=@quantity where odID=id;
    select 'update Success.';
end |
\d ; 

--11. 綜合查詢:
--a. 指定客戶查詢訂單,含訂單明細
\d |
create procedure a(in id int)
begin
select o.orderid,o.onum,o.customerID,od.odid,od.odnum,od.productid,od.unitprice,od.quantity
from orders o
join customers c using(customerID)
join `order details` od on (o.onum = od.odnum)
where c.customerID=id;
end |
\d ;


--b. 指定客戶查詢訂單總金額
\d |
create procedure b(in id int)
begin
select c.customerID,floor(sum(od.unitprice*od.quantity)) as total
from orders o
join customers c using(customerID)
join `order details` od on (o.onum = od.odnum)
where c.customerID=id;

end |
\d ;


--c. 指定商品查詢訂單中的客戶, 例如: 商品P001的客戶有哪些,買幾個
--d. 指定供應商查詢訂單中的商品清單