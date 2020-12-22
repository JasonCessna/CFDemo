 <cfoutput>
<cfinclude template="functions.cfm">
<!DOCTYPE HTML>
<html>
<header>

<!--- jQuery UI CSS --->

<link rel="stylesheet" href="jquery-ui-1.12.1.custom/jquery-ui.min.css">
<link rel="stylesheet" href="jquery-ui-1.12.1.custom/jquery-ui.theme.min.css">

<!--- DataTables CSS --->
<link rel="stylesheet" href="//cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css">

<!--- jQuery JS --->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="http://#CGI.HTTP_HOST#/demo/jquery-ui-1.12.1.custom/jquery-ui.js"></script>
<!--- I usually don't use jQuery's UI directly, instead opting for a library more devoted to it like Bootstrap, so I threw the whole kitchen sink into this JS file. Definitely wouldn't do that in the future since I'm probably only using 1/1000th of this file and had to save it locally. --->

<!--- DataTables JS --->
<script type="text/javascript" src="//cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>


<!--- google charts JS --->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>		

	
</header>

<body>

	<div id="tabs">
		<ul>
			<li id="regions-li"><a href="##tabs_Regions">Sales By Region</a></li>
			<li id="customers-li"><a href="##tabs_Customers">Customers</a></li>
		</ul>

		<div id="tabs_Regions">
			<cfinclude template="regions.cfm">
		</div>
		<div id="tabs_Customers">
			<cfinclude template="customers.cfm">
		</div>

	</div>
	
</body>
</html>

<script>
  $( function() {
    $( "##tabs" ).tabs({
      collapsible: true
    });
  } );
</script>



</cfoutput>