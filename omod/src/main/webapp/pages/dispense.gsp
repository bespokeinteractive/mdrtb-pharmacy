<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Dispense Drugs"])
%>

<script>
	jq(function () {
	
	
	
		
		jq("#qtr").val(${qtrs});
	});
</script>

<style>
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.name {
		color: #f26522;
	}
	.budget-box{
		border: 1px solid #d3d3d3;
		border-top: 2px solid #363463;
		height: auto;
		margin: 15px 0 0 0;
		padding-bottom: 5px;
	}
	.budget-box div{
		width: 36%;
		display: inline-block;
	}
	.budget-box label{
		display: inherit;
		padding: 2px 10px;
		margin: 10px 0 0 0;
		width: 60px;

	}
	input, form input, select, form select, ul.select, form ul.select, textarea {
		min-width: 0;
		display: inline-block;
		width: 230px;
		height: 38px;
	}
	input, select, textarea, form ul.select, .form input, .form select, .form textarea, .form ul.select {
		color: #363463;
		padding: 5px 10px;
		background-color: #FFF;
		border: 1px solid #DDD;
	}
	textarea{
		resize: none;
		height: 80px;
		margin-top: 2px;
		width: 400px;
	}
	#date-created label{
		display: inline-block;
	}
</style>


<% if (program.programId == 1){ %>
	${ui.includeFragment("mdrtbpharmacy", "dispensetb")}
<% } else if (program.programId == 2) { %>
	${ui.includeFragment("mdrtbpharmacy", "dispensedr")}
<% } else { %>
	404 - Page Not Found
<% } %>
