<cfscript>

	public function getMinMaxOrderDates(){
		qOrderDates = new Query();
		qOrderDates.setSQL("
			select min(orderDate) as minDate, max(orderDate) as maxDate from orders
		");
		retOrderDates = qOrderDates.execute().getResult();
		return {minDate: retOrderDates.minDate, maxDate: retOrderDates.maxDate};
		//return {minDate: DateFormat(retOrderDates.minDate,"mm/dd/YYYY"), maxDate: DateFormat(retOrderDates.maxDate,"mm/dd/YYYY")};
	}


	public function getRegionData(required struct rc){
		regionData = [];
		/*
		This is a cheap way to do dynamic queries, I would usually approach the query from a different standpoint using cf's query param for form/URL elements like this. I would also encrypt the URL especially if it were a public facing application. However, this is an easy way to just demonstrate some usages of business logic.
		*/
		whereStatement = " where 1=1 ";
		if(structKeyExists(rc,"FROMDATE") && len(trim(rc.FROMDATE)) > 0 ){
			whereStatement &= " and ord.orderDate >= '" & rc.FROMDATE & "' ";
		}
		if(structKeyExists(rc,"TODATE")   && len(trim(rc.TODATE)) > 0 ){
			whereStatement &= " and ord.orderDate <= '" & rc.TODATE & "' ";
		}

		if(structKeyExists(rc,"GROUPBY") AND rc.GROUPBY == "byOrders"){

			arrayAppend(regionData,["Country","Orders"]);
			qRegionOrderCount = new Query();
				qRegionOrderCount.setSQL("
					select count(ord.orderNumber) as totalOrders, case when cust.country = 'USA' then 'United States' else cust.country end  as country 
					from customers cust
					inner join orders ord
					on cust.customerNumber = ord.customerNumber
					#whereStatement#
					group by cust.country
			");


			retRegionOrderCount = qRegionOrderCount.execute().getResult();

			for(orders in retRegionOrderCount){
				arrayAppend(regionData,[orders.country,orders.totalOrders]);
			}
		}

		else if(structKeyExists(rc,"GROUPBY") AND rc.GROUPBY == "bySales"){

			arrayAppend(regionData,["Country","Sales"]);
			qRegionSales = new Query();
			qRegionSales.setSQL("
				select sum(orderdet.quantityOrdered * orderdet.priceEach) as totalSales, case when cust.country = 'USA' then 'United States' else cust.country end  as country
				from customers cust
				inner join orders ord
				on cust.customerNumber = ord.customerNumber
				inner join orderdetails orderdet
				on ord.orderNumber = orderdet.orderNumber
				#whereStatement#	
				group by cust.country
			");

			retRegionSales = qRegionSales.execute().getResult();
			for(sales in retRegionSales){
				arrayAppend(regionData,[sales.country,sales.totalSales]);
			}

		}
		else {return [["",""]];}
		
		
		return regionData;

	}	

	public function getCustomerData(){

		customerFullData = {}
/* 
In this query I would have tested the efficiency of two seperate queries vs an Outer Apply, but as I'm using MySQL right now I would have to do something like a Lateral, which I honestly don't know that it would work in SQL Server the same. So for the sake of having it work on any system, I'm just using two different queries and joining them in a structure. More work on the CF server and less on the SQL server, which is usually the better route anyway depending on how the servers are set up.
*/

		qCustomerData = new Query();
		qCustomerData.setSQL("
			select customerNumber, customerName, contactLastName, contactFirstName, phone, 
			city, state, country, creditLimit
			from customers
		");

		retCustomerData = qCustomerData.execute().getResult();

		for(customer in retCustomerData){
			customerFullData[customer.customerNumber] = {
				"customerNumber": customer.customerNumber, "customerName": customer.customerName, "contactLastName": customer.contactLastName, 
				"contactFirstName": customer.contactFirstName, "phone": customer.phone, "city": customer.city, 
				"state": customer.state, "country": customer.country, "creditLimit": numberFormat(customer.creditLimit,"$,"), "totalSales": "$0"
			};
		}

		qCustomerSales = new Query();
		qCustomerSales.setSQL("
			select customer.customerNumber, sum(orderdet.quantityOrdered * orderdet.priceEach) as totalSales
			from customers customer
			inner join orders ord
			on customer.customerNumber = ord.CustomerNumber
			inner join orderdetails orderdet
			on ord.orderNumber = orderdet.orderNumber
			group by customer.customerNumber
		");

		retCustomerSales = qCustomerSales.execute().getResult();

		for(sales in retCustomerSales){
			//unnecessary check, but I feel naked without doing it.
			if(structKeyExists(customerFullData,sales.customerNumber)){
					customerFullData[sales.customerNumber].totalSales = numberFormat(sales.totalSales,"$,");
			}
		}

		//This is the bad part; since I have to merge two queries, it's technically faster to just loop through two queries and then a structure in order to populate the final array instead of performing a lookup operation (potentially O(n^2) that would be required if I just started with an array of structures to add the second query's value into it while just looping through the first query).
		customerArray = arrayNew(1); 
		for(key in customerFullData){
			arrayAppend(customerArray,customerFullData[key]);
		}
		return customerArray;

	}
</cfscript>