<cfoutput>

<div class="h4">Customer Information</div>

<div class="customerTableHolder">
	<table id="customerDataTable" class="display" width="100%">
		<thead>
			<tr>
				<th>ID##</th>
				<th>Customer</th>
				<th>Contact First Name</th>
				<th>Last Name</th>
				<th>Phone</th>
				<th>City</th>
				<th>State</th>
				<th>Country</th>
				<th>Credit Limit</th>
				<th>Sales Total</th>
			</tr>
		</thead>
	</table>
</div>

<script>
	<!---get data for customers (static view) --->
	var customerDataSet = #SerializeJSON(getCustomerData())#;
	console.log(customerDataSet);

$("##customerDataTable").DataTable({
	data: customerDataSet,
	 columns: [
            { data: "customerNumber" },
            { data: "customerName" },
            { data: "contactFirstName" },
            { data: "contactLastName" },
            { data: "phone" },
            { data: "city" },
            { data: "state" },
            { data: "country" },
            { data: "creditLimit" },
            { data: "totalSales" }
        ]       
});
</script>	

</cfoutput>