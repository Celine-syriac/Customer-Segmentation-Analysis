create table dspro.swiggy
(id int,
cust_id varchar(10),
order_id int,
partner_code int,
outlet varchar(20),
bill_amount int,                                                                 
order_date date,
comments varchar(20));

insert into dspro.swiggy
values
(1,"SW1005",700,50,"KFC",753, "2021-10-10" ,"Door locked"),
(2,"SW1006",710,59,"PIZZA HUT",1496,"2021-09-01","In-time delivery"),
(3,"SW1005",720,59,"DOMINOS",990,"2021-12-10",null),
(4,"SW1005",707,50,"PIZZA HUT",2475,"2021-12-11",nulL),
(5,"SW1006",770,59,"KFC",1250,"2021-11-17","NO RESPONSE"),
(6,"SW1020",1000,119,"PIZZA HUT",1400,"2021-11-18","IN TIME DELIVERY"),
(7,"SW2035",1079,135,"DOMINOS",1750,"2021-11-19",null),
(8,"SW1020",1083,59,"KFC",1250,"2021-11-20",null),
(11,"SW1020",1100,150,"PIZZA HUT",1950,"2021-12-24","LATE DELIVERY"),
(9, "SW2035",1095,119,"PIZZA HUT",1270,"2021-11-21","LATE DELIVERY"),
(10,"SW1005",729,135,"KFC",1000,"2021-09-10","DELIVERED"),
(1,"SW1005",700,50,"KFC",753,"2021-10-10","Door locked"),
(2,"SW1006",710,59,"PIZZA HUT",1496,"2021-09-01","IN TIME DELIVERY"),
(3,"SW1005",720,59,"DOMINOS",990,"2021-12-10",null),
(4,"SW1005",707,50,"PIZZA HUT",2475,"2021-12-11",null);

#Q1: find the count of duplicate rows in the swiggy table
Select id,count(id) from dspro.swiggy
Group by id
Having count(id)>1
Order by count(id) desc;

#Q2: Remove Duplicate records from the table
/*Step1 create a new table by taking uniques record from original table*/
create table dspro.swiggy1
as
select distinct * from dspro.swiggy;
/*Step 2:Delete the original table*/
drop table dspro.swiggy;
/*Step3:Rename the new table to original table name*/
rename table dspro.swiggy1 to dspro.swiggy;


#Q3: Print records from row number 4 to 9
select * from dspro.swiggy
limit 3,6;

#Q4: Find the latest order placed by customers.
with latest_order as
(select cust_id,outlet,order_date,
row_number() over(partition by cust_id order by order_date desc) as latest_ord_dt from dspro.swiggy)
select * from latest_order
where latest_ord_dt=1;

#Q5: Print order_id, partner_code, order_date, comment (No issues in place of null else comment).
select order_id,partner_code,order_date,
(case 
when comments is null then "no issues"
else comments end) as comments
from dspro.swiggy;

#Q6: Print outlet wise order count, cumulative order count, total bill_amount, cumulative bill_amount.
select a.outlet, a.order_cnt,
@cumulative_cnt:=@cumulative_cnt+a.order_cnt as cumulative_cnt,
a.total_sale,
@cum_sale:=@cum_sale+a.total_sale as cum_sale
from 
(select outlet,count(order_id) as order_cnt,sum(bill_amount) as total_sale from dspro.swiggy
group by outlet) a
join
(select @cumulative_cnt:=0,@cum_sale:=0) b
order by a.outlet;

#Q7: Print cust_id wise, Outlet wise 'total number of orders'.
select cust_id,
sum(if(outlet="KFC",1,0)) KFC,
sum(if(outlet="DOMINOS",1,0)) Dominos,
sum(if(outlet="PIZZA HUT",1,0)) Pizza_hut
from dspro.swiggy
group by cust_id;

#Q8: Print cust_id wise, Outlet wise 'total sales.
select cust_id,
sum(if(outlet="KFC",bill_amount,0)) KFC,
sum(if(outlet="DOMINOS",bill_amount,0)) DOMINOS,
sum(if(outlet="PIZZA HUT",bill_amount,0)) Pizza_hut
from dspro.swiggy
group by cust_id;




