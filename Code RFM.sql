 --Subquery 																	
	select *,																
	       ntile(4) over ( order by recency asc) as R ,											
	       ntile(4) over ( order by frequency asc) as F ,										
	       ntile(4) over ( order by revenue asc) as M ,											
	       concat(ntile(4) over ( order by recency asc),										
	           ntile(4) over ( order by frequency asc),											
	           ntile(4) over ( order by revenue asc)) as RFM										
	from																
	(select CustomerID,														
	              sum(GMV)/datediff(year,max(R.created_date),'2022-09-01') as Revenue ,							
	              datediff(day,max(Purchase_Date),'2022-09-01') as recency,									
	              cast(count(cast(purchase_date as date)) as float)/cast(datediff(year,max(R.created_date),'2022-09-01') as float) as Frequency
	from Customer_Transaction T													
	join Customer_Registered R on T.customerID = R.ID											
	where stopdate is null and customerid != 0											
	group by CustomerID) A														
																	
																	
--CTE 																	
																	
with data_processing as (															
select CustomerID,																
              sum(GMV)/datediff(year,max(R.created_date),'2022-09-01') as Revenue ,								
              datediff(day,max(Purchase_Date),'2022-09-01') as recency,										
              cast(count(cast(purchase_date as date)) as float)/cast(datediff(year,max(R.created_date),'2022-09-01') as float) as Frequency	
from Customer_Transaction T															
join Customer_Registered R on T.customerID = R.ID													
where stopdate is null and customerid != 0														
group by CustomerID)															
select *,																	
       ntile(4) over ( order by recency asc) as R ,												
       ntile(4) over ( order by frequency asc) as F ,											
       ntile(4) over ( order by revenue asc) as M ,												
       concat(ntile(4) over ( order by recency asc),											
           ntile(4) over ( order by frequency asc),												
           ntile(4) over ( order by revenue asc)) as RFM											
from data_processing															
																	
--Temporary table																
																	
select CustomerID,															
              sum(GMV)/datediff(year,max(R.created_date),'2022-09-01') as Revenue ,								
              datediff(day,max(Purchase_Date),'2022-09-01') as recency,										
              cast(count(cast(purchase_date as date)) as float)/cast(datediff(year,max(R.created_date),'2022-09-01') as float) as Frequency	
into #temp																
from Customer_Transaction T														
join Customer_Registered R on T.customerID = R.ID												
where stopdate is null and customerid != 0												
group by CustomerID															
select *,																	
       ntile(4) over ( order by recency asc) as R ,												
       ntile(4) over ( order by frequency asc) as F ,											
       ntile(4) over ( order by revenue asc) as M ,												
       concat(ntile(4) over ( order by recency asc),											
           ntile(4) over ( order by frequency asc),												
           ntile(4) over ( order by revenue asc)) as RFM											
from #temp																
drop table #temp																


