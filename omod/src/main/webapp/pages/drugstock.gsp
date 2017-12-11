<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Drug Stock"])
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
	#drugstock{
		font-size: 14px;
		margin-top: 2px;
	}
	#drugstock td:nth-child(5),
	#drugstock td:last-child{
		text-align: right;
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
			Drug Stock
		</li>
	</ul>
</div>

<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span><i class="icon-copy small"></i>VIEW DRUG STOCK &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>

	<div class="show-icon">
		<i class="icon-globe small"></i>${location.name.toUpperCase()}&nbsp;
	</div>
	<div class="clear both"></div>
</div>

<table id="drugstock">
    <thead>
		<th style="width:1px">#</th>
		<th>DRUG NAME</th>
		<th style="width:200px;">FORMULATION</th>
		<th style="width:250px;">CATEGORY</th>
		<th style="width:90px">AVAILABLE</th>
		<th style="width:90px">REORDER</th>
    </thead>

    <tbody>
		<% items.eachWithIndex { itm, index -> %>
			<tr>
				<td>${index+1}</td>
				<td>${itm.drug.drug.name.toUpperCase()}</td>
				<td>${itm.drug.formulation.name.toUpperCase() +' '+ itm.drug.formulation.dosage}</td>
				<td>${itm.drug.category.name.toUpperCase()}</td>
				<td>${String.format("%1\$,.2f",itm.available)}</td>
				<td>${String.format("%1\$,.2f",itm.reorder)}</td>
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
<div class="clear both"></div>