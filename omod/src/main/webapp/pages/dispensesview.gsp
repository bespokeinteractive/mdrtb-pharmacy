<%
    ui.decorateWith("appui", "standardEmrPage", [title: "View Dispenses"])
	ui.includeJavascript("mdrtbdashboard", "moment.js")
%>

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
		margin: 5px 0 0 0;
		padding-bottom: 5px;
	}
	.budget-box div{
		width: 36%;
		display: inline-block;
	}
	.budget-box label{
		display: inherit;
		padding: 2px 10px;
		margin: 5px 0 0 0;
		width: 60px;
		font-size: 0.95em;
		color: #555;

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
		height: 120px;
		margin-top: 2px;
		width: 400px;
	}
	#date-created label{
		display: inline-block;
	}
	#dispenseTable {
		margin-top: 2px;
		font-size: 12px;
	}
	#dispenseTable th:nth-child(10),
	#dispenseTable td:nth-child(10){
		width:2px;
		padding:0px;
	}
	#dispenseTable td:nth-child(4),
	#dispenseTable td:nth-child(5){
		text-align:center;
	}
	.button.confirm{
		margin-right:0px;
	}
	.dialog-content .confirmation{
		margin-bottom: 20px;
	}
	#modal-overlay {
		background: #000 none repeat scroll 0 0;
		opacity: 0.3 !important;
	}
	.show-icon {
		float: right;
		font-family: "OpenSansBold";
		font-size: 1.5em;
		margin: 0 0 -5px 0;
	}
</style>

<div class="example">
	<ul id="breadcrumbs">
		<li>
			<a href="${ui.pageLink('referenceapplication', 'home')}">
				<i class="icon-home small"></i></a>
		</li>

		<li>
			<i class="icon-chevron-right link"></i>
			<a href="dashboard.page">Pharmacy</a>
		</li>
		
		<li>
			<i class="icon-chevron-right link"></i>
			<a href="dispenses.page">Dispenses</a>
		</li>

		<li>
			<i class="icon-chevron-right link"></i>
			View Dispense
		</li>
	</ul>
</div>

<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span><i class="icon-copy small"></i>VIEW DISPENSE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>

	<div class="show-icon">
		<i class="icon-globe small"></i>${dispense.location.name.toUpperCase()}&nbsp;
	</div>
	<div class="clear both"></div>
	
	<div class="budget-box">
		<div>
			<Label>Date</Label>${ui.formatDatePretty(dispense.date)}
		</div>
		
		<div style="width: 63%; float: right">
			<label style="display: inline-block">Notes</label>${dispense.description==''?'N/A':dispense.description}
		</div>
		
		<div>
			<label>Quarter</label>${dispense.period}
		</div>
		
		<span class="clear both"></span>
	</div>

	<table id="dispenseTable">
		<thead>
			<th style="width:1px">#</th>
			<th style="width:110px;">IDENTIFIER</th>
			<th>PATIENTS</th>
			<th style="width:30px;">AGE</th>
			<th style="width:50px;">WEIGHT</th>
			<th style="width:50px;">RHZE</th>
			<th style="width:50px;">RH</th>
			<th style="width:50px;">RHZ</th>
			<th style="width:55px;">RH(PEDI)</th>
			<th style="width:2px;"></th>
			<th style="width:50px;">ETHA</th>
			<th style="width:50px;">INH</th>
		</thead>
		
		<tbody>
			<% details.eachWithIndex { dtls, index -> %>
				<tr>
					<td>${index+1}</td>
					<td>${dtls.programDetails.tbmuNumber}</td>
					<td>${dtls.programDetails.patientProgram.patient.names.toString().toUpperCase()}</td>
					<td>${dtls.programDetails.patientProgram.patient.age}</td>
					<td>${dtls.programDetails.weight}</td>
					<td>${String.format("%1\$,.2f",dtls.rhze)}</td>
					<td>${String.format("%1\$,.2f",dtls.rh)}</td>
					<td>${String.format("%1\$,.2f",dtls.rhz)}</td>
					<td>${String.format("%1\$,.2f",dtls.rhp)}</td>
					<td>&nbsp;</td>
					<td>${String.format("%1\$,.2f",dtls.eth)}</td>
					<td>${String.format("%1\$,.2f",dtls.iso)}</td>
				</tr>
			<% } %>
		</tbody>
	</table>
	
	<div style="margin: 5px 0 10px;">
		<span class="button task right" id="addBudget">
			<i class="icon-print small"></i>
			Print
		</span>
	</div>
</div>