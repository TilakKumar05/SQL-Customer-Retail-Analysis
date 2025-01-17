select * From customer
select * From Transactions
select * From prod_cat_info
Alter table [Transactions] Alter column [transaction_id]  Bigint not null
Alter table [Transactions] Alter column [cust_id]  int not null
Alter table [Transactions] Alter column [prod_cat_code] tinyint  not null
Alter table [Transactions] Alter column [prod_subcat_code]  tinyint not null
Alter table [Transactions] Alter column [Qty]  bigint not null
Alter table [Transactions] Alter column [Rate]  bigint not null
Alter table [Transactions] Alter column [Tax]  float not null

--Data preparation Questions
--Q1
Select count(*) as Rows_in_Customer_table
From Customer

Select count(*) as Rows_in_Transaction_table
From Transactions

Select count(*) as Rows_in_Product_category_table
From prod_cat_info

--Q2
Select count(Qty) as Transaction_having_returns
From Transactions
where Qty < 0

--Q3
update Transactions
set tran_date = CONVERT(date,tran_date,103)

--Q4
Select datediff(DAY,'2011-02-25','2014-02-28') as No_of_days,
datediff(Month,'2011-02-25','2014-02-28') as No_of_months,
datediff(YEAR,'2011-02-25','2014-02-28') as No_of_years

--Q5
Select prod_cat , prod_subcat
From prod_cat_info
where prod_subcat = 'DIY'
--Subcategory DIY belongs to category Books.

--------------------------------------------------------------------------------------------------------------------------------------------------


--Data Analysis
--Q1 Mode of transaction or Channel is not given so used store_type
Select  Top 1 Store_type as Most_frequently_used_channel , count(transaction_id) as Count_of_Transactions
FROM Transactions
Group By Store_type
Order By Count_of_Transactions Desc

--Q2
Select Gender, count(customer_id) as [Count]
From Customer
Where Gender = 'M' or Gender = 'F'
group by Gender

--Q3
--City name table doesn't exist so doing it based on city_code
Select  Top 1 city_code , Count(customer_Id) as max_customer
From Customer
Group By city_code
order by max_customer Desc

--Q4
Select prod_cat , Count(prod_subcat) as Number_of_subcategory_under_Books 
From prod_cat_info
where prod_cat = 'Books'
Group by prod_cat


--Q5
Select prod_cat, Max(Qty) as Max_Qty_ordered
From prod_cat_info
	Join Transactions
		on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = Transactions.prod_subcat_code
Group by prod_cat


--Q6
Alter Table [Transactions] Alter column [total_amt] float  


Select prod_cat,  Sum(total_amt) as Total_revenue
From Transactions 
	inner Join prod_cat_info
		on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = Transactions.prod_subcat_code	
Where prod_cat = 'Electronics' or prod_cat = 'Books'
Group by prod_cat

--Q7
Select count(cust_id) as count_of_cust_id 
From (Select cust_id, count(transaction_id)  as Count_of_Transactions
From Transactions
where Qty > 0
Group by cust_id
having count(transaction_id) > 10) [Count_of_Transactions]

--Q8
Select Store_type,  Sum(total_amt) as Combined_Revenue
From Transactions
	Inner join prod_cat_info
		on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = Transactions.prod_subcat_code
where prod_cat = 'Electronics' or prod_cat = 'Clothing'
Group by Store_type 
having Store_type = 'Flagship store'

--Q9
Select Sum(total_amt) as Total_Revenue, prod_subcat
From Transactions
Inner join prod_cat_info on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = Transactions.prod_subcat_code
Inner join Customer on Customer.customer_Id = Transactions.cust_id 
where Gender = 'M' and prod_cat = 'Electronics'
Group by prod_subcat

--Q10
Select Top 5 prod_subcat,total_amt, Concat(total_amt * 100/  (select sum(total_amt) From Transactions),'%') AS percentage
From Transactions
Inner Join prod_cat_info
	on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = Transactions.prod_subcat_code
Group by prod_subcat, total_amt
Order by total_amt Desc

--Q11
Select total_amt, 
 Datediff(Year,Convert(date,DOB,103),tran_date) as Count_of_age,
 Datediff(Day,tran_date,(Select Max(tran_date) From Transactions)) as Count_of_Tran_days
 From Transactions
 Inner join Customer on Customer.customer_Id = Transactions.cust_id 
 where Datediff(Day,tran_date,(Select Max(tran_date) From Transactions)) <=30 And
 (Datediff(Year,Convert(date,DOB,103),tran_date) >=25 and Datediff(Year,Convert(date,DOB,103),tran_date) <= 35) 

 --Q12
SELECT TOP 1 prod_cat,SUM(Qty) as Max_Returns
FROM
(SELECT transaction_id,Qty,tran_date,prod_cat,
DATEDIFF(MONTH,tran_date,(SELECT MAX(tran_date) FROM Transactions)) as Last_3_month_Transactions
FROM
Transactions
Inner join prod_cat_info
		on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = prod_cat_info.prod_sub_cat_code
Where Qty < 0 AND DATEDIFF(MONTH,tran_date,(SELECT MAX(tran_date) FROM Transactions)) <= 3) as Last_3_Month_transactions
Group By prod_cat
Order By Sum(Qty) 

--Q13
Select Top 1 store_type , sum(Qty) as Qty_sold, Sum(total_amt) as Sales_amt
From Transactions
Group by Store_type
Order by sum(Qty) desc

--Q14
Select prod_cat , Avg(total_amt) as Avg_Revenue
From Transactions
	Inner join prod_cat_info
		on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = prod_cat_info.prod_sub_cat_code
Group by prod_cat
having Avg(total_amt) > (SELECT AVG(total_amt) FROM Transactions)

--Q15
Select Top 5 prod_cat, prod_subcat, Sum(Qty) as Qty_sold,Avg(total_amt) as Avg_Revenue, Sum(total_amt) as Total_Revenue
From Transactions
	Inner join prod_cat_info
		on prod_cat_info.prod_cat_code = Transactions.prod_cat_code and prod_cat_info.prod_sub_cat_code = prod_cat_info.prod_sub_cat_code
Group by prod_subcat, prod_cat
order by Qty_sold Desc




