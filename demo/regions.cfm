<cfoutput>

<style>

th, td {
  padding: 10px;
}
</style>

<script type="text/javascript" src='http://#CGI.HTTP_HOST#/demo/geochart.js'></script>	

<cfset minMaxDates = getMinMaxOrderDates()>
<cfparam name="groupBy" default="bySales">
<cfset minDate = minMaxDates.minDate>
<cfset maxDate = minMaxDates.maxDate>
<cfparam name="fromDate" default="#minDate#">
<cfparam name="toDate" default="#maxDate#">

<div id="options" >
<cfform>
	<table>
		<tr>
			<td>	
				<label for="fromDate">From:<input name="fromDate" id="fromDate" class="datepicker" type="date" <cfif len(trim(fromDate)) GT 0 > value="#fromDate#" </cfif>
					min="#minDate#" max="#maxDate#"></label>
			</td>
			<td>	
				<label for="toDate">To: <input name="toDate" class="datepicker" id="toDate" type="date"  <cfif len(trim(toDate)) GT 0 > value="#toDate#" </cfif>
					min="#minDate#" max="#maxDate#"></label>
			</td>
			<td>
				<label for="bySales">Total Sales <input type="radio" id="bySales" name="groupBy" value="bySales" <cfif groupBy EQ "bySales">checked="true"</cfif>></label>
				<label for="byOrders">Order Count <input type="radio" id="byOrders" name="groupBy" value="byOrders" <cfif groupBy EQ "byOrders">checked="true"</cfif>></label>
			</td>
			<td>
				<button name="submit">Reload</button>
			</td>
		</tr>
	</table>
</cfform>

</div>


<div id="regions_div"> </div>



<script>

	var regionSalesData = #SerializeJSON(getRegionData({groupBy=groupBy, fromDate=fromDate, toDate=toDate}))#;

    function getData(){
    	return regionSalesData
    }



</script>

</cfoutput>