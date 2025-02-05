---Dataset – Alibaba dataset
use web_Alibaba
-- Define a SQL table to store the given dataset.
-- create database called web_Alibaba.db
create database web_Alibaba;
Go

-- create table Alibabdata
create table Alibab_data (
						 Serial_no varchar(100) NOT NULL primary key,
						 Name int NULL ,
						 Shipping_city varchar(100) NULL ,
						 Category  varchar(100) NULL ,
						 Sub_category varchar(100) NULL ,
						 Segment varchar(100) NULL ,
						 Brand  varchar(100) NULL ,
						 Brick  varchar(100) NULL ,
						 Item_NM varchar(100) NULL ,
						 Color varchar(100) NULL ,
						 Size varchar(100) NULL ,
						 Sale_Flag  varchar(100) NULL ,
						 Payment_Method varchar(100) NULL ,
						 coupon_money_effective decimal(12,5) null,
						 Quantity int NULL,
						 Cost_Price decimal(12,5) null,
						 Item_Price int NULL,
						 Special_Price_effective decimal(12,5) null,
						 paid_pr_effective decimal(12,5) null,
						 Value_CM1 decimal(12,5) null,
						 Value_CM2 decimal(12,5) null,
						 Special_price int NULL
)


-- drop the table which is craete my mistake.
drop table [dbo].[Alibaba_002];


-- alter tanble to create primary key to the new table. 

-- we have to make the columns which is has primary key not nullable so change the data type to varchar(100) not null.
alter table Payment_Methods
alter column Payment_Method varchar(100) not null;

-- add primary key to fact table.
alter table Payment_Methods
add constraint PK_Payment_Methods primary key (Payment_Method);

-- change the columns name S_no to be nullable not null to make it primary key.
alter table Alibaba_001
alter column S_no int not null;

alter table Alibaba_001
add primary key (S_no);

-- add the forgein key to chilled table.
alter table Payment_Methods
add foreign key (Payment_Method)
references [Alibaba_001](S_no)


-- i have to match thendata type to create the foriegn key
alter table Alibaba_001
alter column Payment_Method varchar(100)

-- new we can create the primary key for the Alibaba_001 table
-- for instance alter table to add foreign key to Alibaba_001 table and primary ket for Payment_mathods table (chilled table)
ALTER TABLE Alibaba_001
add FOREIGN KEY (Payment_Method)
REFERENCES Payment_Methods(Payment_Method);




alter table Payment_Methods
add primary key Payment_Method


--. Load the provided dataset into the SQL table. Done...

-- 3 - Retrieve all columns from the table for the first 10 rows.
select top 10 * 
from 
	dbo.Alibaba_001;

--4. Display the products where the shipping city is 'New York'

select * 
from 
	dbo.Alibaba_001
where 
	Shipping_city = 'New York'


-- 5. Retrieve the top 5 products with the highest item price.

select 
		top 5 Item_NM as product, 
		Item_Price
from 
	dbo.Alibaba_001

-- 6. Calculate the average quantity sold
select 
	AVG(Quantity) as AVG_quantity_sold
from 
	dbo.Alibaba_001

-- 7. Group the data by category and display the total quantity sold for each category.

select Category ,
	    sum(Quantity) total_Qty_sold
from
	dbo.Alibaba_001
group by 
	Category
order by sum(Quantity) desc;


-- 8. Create a new table for payment methods and join it with the main table to display product names and 
-- their payment methods.

-- create new table with group by paymant method.

select * into Payment_Methods from ( select 
	Payment_Method
from
	dbo.Alibaba_001
group by
	Payment_Method
) payment


-- create query to dislapy the product name & payment method...
select 
	A.Item_NM as product_names ,
	P.Payment_Method 
from
	dbo.Alibaba_001 A
join
	Payment_Methods P
on	
	A.Payment_Method = P.Payment_Method



--9. Find products where the cost price is greater than the average cost price.



select * 
from
	Alibaba_001
where Cost_Price >(select 
						AVG(Cost_Price) average_cost
					from 
						Alibaba_001);

-- 10. Calculate the total special price for products in the 'Electronics' category. we just have watches in electronic

-- Sub_category 
-- Segment
-- 
select * from Alibaba_001





SELECT 
    Category, 
    Name, 
    sum(Special_Price_effective) as Special_Price
FROM
    Alibaba_001
GROUP BY 
    Category , Name
HAVING
    Category = 'WATCHES';



--11. Increase the cost price by 10% for products in the 'Clothing' category. {Women Apparel,Men Apparel}
select * from Alibaba_001


SELECT 
    Category, 
    Name, 
    cast(Cost_Price + (Cost_Price * 0.1) as decimal(10, 2)) as New_Cost_Price
FROM
    Alibaba_001
where
    Category = 'Men Apparel' OR  Category = 'Women Apparel';



--12. Add a new record for a product with necessary details.


-- craete auto_increment to automaticly add the value in primary key
alter table Alibaba_001
alter column S_no auto_increment;
-- create new column with auto increment in sql server use identity(start 1,incerment by 1)

alter table Alibaba_001
add new_s_no int identity(1,1);

-- drop the primary key for s_no column
alter table Alibaba_001
drop constraint [PK__Alibaba___A3D670B2AF91CCA1];

-- create primary key for new_s_no
alter table Alibaba_001
add primary key (new_s_no);

-- change the s_no column to make it nullable
alter table Alibaba_001
alter column S_no int null;

-- create the for
-- i have to identity_insert in Alibaba001 table on;

SET IDENTITY_INSERT Alibaba_001 ON;

INSERT INTO Alibaba_001 
(new_s_no, Name, Shipping_City, Category, Item_NM, Payment_Method, Quantity, Cost_Price, Item_Price) 
VALUES
(,'Mohamed Ashraf', 'Alexandria', 'Men Apparel', 'Boxer Cotonel', 'Prepaid', 10, 1000, 100);

SET IDENTITY_INSERT Alibaba_001 OFF;

--13. Remove all products where the sale flag is 0

delete from Alibaba_001 
where sale_Flag ='Not on Sale'




select 
	sale_Flag , count(*)
from 
	Alibaba_001
group by sale_Flag


--14. Create a new column 'Discount_Type' that categorizes products based on their item price: 'High' if 
--above $200, 'Medium' if between $100 and $200, 'Low' if below $100.

-- create new column Discount_Type
alter table Alibaba_001
add Discount_Type varchar(50)

-- update the value with if condation
update Alibaba_001
set Discount_Type  = case 
	when Item_Price > 200 then 'High'
	when Item_Price between 100 and 200 then 'Medium'
	when Item_Price < 100 then 'Low'
end;


-- 15. Rank the products based on their special prices within each category.

select 
	category,
	Item_NM, 
	Special_Price_effective,
	RANK() over (partition by category order by Special_Price_effective desc) as rank_product
from Alibaba_001

-- hint  :: row1_number() funcation ... 
-- this funcation rank the number of row has the same number pf partition by and appear as count

-- hint  :: rank() funcation ...
-- this funcation make the same is row number by appear the total number of repeat the value in partition.

select 
	category,
	Item_NM, 
	Special_Price_effective, 
	row_number() over (partition by Special_Price_effective order by Special_Price_effective desc) as rank_product
from Alibaba_001
where 
	Category = 'Women Apparel'
	

--16. Calculate the running total of the quantity sold for each product.
select 
	Item_Nm,
	sum(Quantity) as Quantity_sold_no
from 
	Alibaba_001
group by 
	Item_Nm
order by 2 desc

-- 17. Create a CTE that lists products in the 'Fashion' sub-category with their corresponding brand and color.

select *
from
	Alibaba_001

select Sub_category,count(*)
from
	Alibaba_001
group by 
	Sub_category
	

-- NULL - LIVING 

with Fashion as (select Sub_category,
		   color,
		   Brand
	from 
		Alibaba_001
	where Sub_category is not null and  Sub_category != 'LIVING')

select *  from Fashion
---where Sub_category = 'LIVING'


-- 18. Pivot the data to show the total quantity sold for each category and sub-category.


with cat_list as (select Sub_category
	from
		Alibaba_001
	group by 
		Sub_category)

select *
from
	Alibaba_001 A

join
	cat_list C
on A.Sub_category = C.Sub_category

Pivot
(count(Quantity) 
for Sub_category in ([Sports Apparel],
						[Ethnic],
						[Bags],
						[Womens Footwear],
						[LIVING],
						[Mens Footwear],
						[SUNGLASSES],
						[WATCHES] )) as pivot_table